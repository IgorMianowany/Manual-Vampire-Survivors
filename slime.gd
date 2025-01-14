extends CharacterBody2D

@export var player : Player
@export var speed : float = 75
#@export var speed : float = 0
@export var jump_cooldown : float = 1.5
@export var jump_duration : float = 1
@export var jump_variation : float = 0.75
@export var direction_variation : float = 15
@export var damage : float = 10
@export var knockback_power : float = 1
@export var max_health : float = 10 
@onready var health : float = max_health
@onready var healthbar : TextureProgressBar = $Control/TextureProgressBar 
var jump_timer : float = 0
var direction : Vector2 = Vector2.ZERO
var player_position : Vector2
var is_jumping : bool = false
enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var facing_direction : DirectionEnum
var is_knocked_back : bool = false

@onready var start_pos : Vector2 = position

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	healthbar.max_value = max_health
	healthbar.value = health
	if not is_jumping:
		player_position = player.position + Vector2(randf_range(-direction_variation, direction_variation), randf_range(-direction_variation, direction_variation))
		$Hitbox.monitoring = false
	else:
		$Hitbox.monitoring = true
		
	jump_timer += delta
	
	handle_animation()
	
	if jump_timer > jump_cooldown + randf_range(-jump_variation, jump_variation):
		jump_toward_player()
	
	move_and_slide()

func jump_toward_player() -> void:
	if jump_timer < jump_cooldown + jump_duration:
		is_jumping = true
		if not is_knocked_back:
			velocity = position.direction_to(player_position) * speed
	else:
		is_jumping = false
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		jump_timer = 0

func handle_animation() -> void:
	direction = position.direction_to(player.position)
	if velocity != Vector2.ZERO:
		if direction.x > 0  and jump_timer < jump_cooldown + 0.1:
			if direction.x > direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.RIGHT
			else:
				$AnimatedSprite2D.play("move_down")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.DOWN
		elif jump_timer < jump_cooldown + 0.1:
			if direction.x < direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = true
				facing_direction = DirectionEnum.LEFT
			else:
				$AnimatedSprite2D.play("move_up")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.UP
	else:
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
	if body is Player and is_jumping:
		body.take_damage(damage, position.direction_to(player_position), knockback_power)

func take_damage(damage : float, knockback_direction : Vector2, knockback : float) -> void:
	health -= damage
	velocity = knockback_direction * knockback * speed
	is_knocked_back = true
	await(get_tree().create_timer(1).timeout)
	is_knocked_back = false
	if health <= 0:
		queue_free()
