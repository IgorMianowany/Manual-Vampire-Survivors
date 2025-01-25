class_name Slime
extends CharacterBody2D

@export var player : Player
@export var speed : float = 75
#@export var speed : float = 0
@export var jump_cooldown : float = 1.5
@export var jump_duration : float = .9
@export var jump_variation : float = 0.5
@export var direction_variation : float = 15
@export var damage : float = 10
@export var knockback_power : float = 1
@export var max_health : float = 10 
@export var exp_amount : int = 1
@export var healthbar : TextureProgressBar 
@onready var health : float = max_health
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var experience_pickup := preload("res://experience_pickup.tscn").instantiate()
var player_direction : Vector2
var jump_timer : float = 0
var direction : Vector2 = Vector2.ZERO
var player_position : Vector2
var is_jumping : bool = false
enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var facing_direction : DirectionEnum
var is_knocked_back : bool = false

@onready var start_pos : Vector2 = position

func _ready() -> void:
	set_as_top_level(true)
	@warning_ignore("integer_division")
	max_health += player.get_elapsed_time() / 10
	health = max_health
	

func _physics_process(delta: float) -> void:
	$Control/TextureProgressBar.max_value = max_health
	$Control/TextureProgressBar.value = health
	if not is_jumping:
		player_position = player.global_position + Vector2(randf_range(-direction_variation, direction_variation), randf_range(-direction_variation, direction_variation))
		$SlimeHitbox/CollisionShape2D.disabled = true
	else:
		$SlimeHitbox/CollisionShape2D.disabled = false
		
	jump_timer += delta
	
	var picked_variation = randf_range(0, jump_variation)
	handle_animation(picked_variation)
	if jump_timer > jump_cooldown + picked_variation:
		jump_toward_player(picked_variation)
	
	move_and_slide()

func jump_toward_player(variation : float) -> void:
	var new_direction := Vector2.ZERO
	if jump_timer < jump_cooldown + jump_duration + variation and health >0 :
		is_jumping = true
		if not is_knocked_back:
			# this is a weird way to check if slime reached it's jump destination before finishing the jump
			# in this case it will go back and forth trying to reach exactly this point, instead of keeping the momentum
			# this fixes that case
			new_direction = position.direction_to(player_position)
			if player_direction + new_direction < Vector2(0.001, 0.001) and player_direction + new_direction > Vector2(-0.001, -0.001):
				return
			velocity = position.direction_to(player_position) * speed
			
	else:
		is_jumping = false
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		jump_timer = 0
	player_direction = new_direction

func handle_animation(variation : float) -> void:
	direction = position.direction_to(player.position)
	if health <= 0:
		$AnimatedSprite2D.play("die")
	elif velocity != Vector2.ZERO and not is_knocked_back:
		if direction.x > 0  and jump_timer < jump_cooldown + variation:
			if direction.x > direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.RIGHT
			else:
				$AnimatedSprite2D.play("move_down")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.DOWN
		elif jump_timer < jump_cooldown + variation:
			if direction.x < direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = true
				facing_direction = DirectionEnum.LEFT
			else:
				$AnimatedSprite2D.play("move_up")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.UP
	elif not is_knocked_back:
		if facing_direction == DirectionEnum.RIGHT:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = false
		elif facing_direction == DirectionEnum.DOWN:
			$AnimatedSprite2D.play("idle_down")
			$AnimatedSprite2D.flip_h = false
		elif facing_direction == DirectionEnum.LEFT:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.play("idle_up")
			$AnimatedSprite2D.flip_h = false
			


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and is_jumping and health > 0:
		body.take_damage(damage, position.direction_to(player_position), knockback_power)

func take_damage(incoming_damage : float, knockback_direction : Vector2, knockback : float) -> void:
	health -= incoming_damage
	if health > 0:
		DamageNumbers.display_number(int(incoming_damage), damage_numbers_origin.global_position)
		
		$HitParticles.set_direction(knockback_direction)
		$HitParticles.emitting = true
		velocity = knockback_direction * knockback * speed
		is_knocked_back = true
		$AnimatedSprite2D.play("take_damage")
		flash_white()
		if jump_timer > 0.5:
			jump_timer -= 0.5
		await(get_tree().create_timer(1).timeout)
		is_knocked_back = false
		$HitParticles.emitting = false
	if health <= 0:
		$SlimeHitbox.monitoring = false
		$SlimeHitbox.monitorable = false
		$SlimeHurtbox.monitoring= false
		$SlimeHurtbox.monitorable = false
		await(get_tree().create_timer(1).timeout)
		experience_pickup.experience_points = exp_amount
		get_parent().add_child(experience_pickup)
		experience_pickup.global_position = global_position
		queue_free()

func flash_white() -> void:
	$AnimatedSprite2D.modulate = Color(10,10,10)
	await(get_tree().create_timer(.1).timeout)
	$AnimatedSprite2D.modulate = Color(1,1,1)

func _on_collision_area_body_entered(body: Node2D) -> void:
	if is_knocked_back and body.name != "Player":
		velocity = Vector2.ZERO
		take_damage(1, body.global_position.direction_to(global_position), 0)
