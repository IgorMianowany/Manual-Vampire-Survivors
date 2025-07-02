class_name Enemy
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
@export var money : int = 100 
@onready var health : float = max_health
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var experience_pickup := preload("res://experience_pickup.tscn")
var player_direction : Vector2
var jump_timer : float = 0
var direction : Vector2 = Vector2.ZERO
var player_position : Vector2
var is_jumping : bool = false
var is_dead : bool = false
enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var facing_direction : DirectionEnum
var is_knocked_back : bool = false
var is_poisoned : bool = false
var poison_damage : float = 0
var poison_ticks_left : float = 0
var already_hit_by_chain_lightning : bool = false
var is_first_hit_by_chain_lightning : bool = false
var variation : float
var active : bool = false
var is_pulled : bool = false
var pull_source : Node2D = null
var boids_i_see : Array[Enemy] = []
var screensize : Vector2
var movv := 48
var sprite : AnimatedSprite2D
var repulsion_force : float = 0.1
var collision_calc_cooldown : int = 0
var is_attacking : bool = false
var distance_to_player : float
var frame_counter : int = 15
var color : Color = Color.WHITE


@export var test_name : String

@onready var start_pos : Vector2 = position
@onready var healthbar_new = $Control/Healthbar


func _ready() -> void:
	screensize = get_viewport_rect().size
	set_as_top_level(true)
	PlayerState.slime_count += 1
	#var current_parent = get_parent()
	#while(true):
		#if current_parent.name == "LayerHolder":
			#reparent(current_parent)
			#break
		#current_parent = current_parent.get_parent()
	#@warning_ignore("integer_division")
	#max_health += player.get_elapsed_time() / 10
	player = get_parent().player
	health = max_health
	$PoisonTimer.timeout.connect(take_poison_damage)
	variation = randf_range(0, jump_variation)
	healthbar_new.init_health(max_health)

func _physics_process(_delta: float) -> void:
	#$Control/Label.text = test_name
	#$AnimatedSprite2D.modulate = color

	#if is_pulled:
		#if pull_source != null:
			#direction = global_position.direction_to(pull_source.global_position)
			#var new_speed = clampf(speed * 1000 * (1 / global_position.distance_squared_to(pull_source.global_position)), 0, 75)
			#velocity = direction * new_speed
	#position += velocity.normalized()
	#move_and_slide()
	position += velocity.normalized()

func _process(delta: float) -> void:
	if not active:
		set_physics_process(false)
	else:
		set_physics_process(true)

func handle_animation(animation_variation : float) -> void:
	direction = position.direction_to(player.position)
	if health <= 0:
		$AnimatedSprite2D.play("die")
	elif velocity != Vector2.ZERO and not is_knocked_back:
		if direction.x > 0  and jump_timer < jump_cooldown + jump_duration + animation_variation:
			if direction.x > direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.RIGHT
			else:
				$AnimatedSprite2D.play("move_down")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.DOWN
		elif jump_timer < jump_cooldown + jump_duration + animation_variation:
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

func take_damage(incoming_damage : float, knockback_direction : Vector2, knockback : float, is_poisoning : bool = false, is_crit : bool = false) -> void:	
	if is_poisoning:
		start_poison(PlayerState.poison_damage, PlayerState.poison_duration)
	
	if health > 0:
		var tween : Tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.1).from(15)
		health -= incoming_damage
		healthbar_new.health = health
		$HitParticles.emitting = true
		DamageNumbers.display_number(int(incoming_damage), damage_numbers_origin.global_position, is_crit)
		$HitParticles.set_direction(knockback_direction)
		
		if PlayerState.chain_lightning_ready:
			if PlayerState.enemies_hit_by_chain_lightning.size() == 0:
				PlayerState.start_chain_lightning_timer()
			handle_chain_lightning_logic()
	if health > 0:
		is_knocked_back = true
		velocity = knockback_direction * (knockback * .8) * speed
		$AnimatedSprite2D.play("take_damage")
		if jump_timer > 0.8 and not is_poisoning:
			jump_timer -= 0.8
		await(get_tree().create_timer(.8).timeout)
		is_knocked_back = false
	if health <= 0:
		 #this is done so all the colliders are not in a way after entity death, as 
		 #set_deferred can be wonky when working with a lot of entites of the same type
		for property in get_children():
			if property is Timer:
				continue
			if property is AnimatedSprite2D:
				continue	
			if property is Control:
				continue
			property.global_position = Vector2.ZERO
		active = false
		#$ProjectileDestroyArea.set_deferred("monitorable", false)
		$AnimatedSprite2D.play("die")
		await(get_tree().create_timer(1).timeout)

	$HitParticles.emitting = false

func _on_collision_area_body_entered(body: Node2D) -> void:
	if is_knocked_back and body.name != "Player":
		velocity = Vector2.ZERO
		take_damage(1, body.global_position.direction_to(global_position), 0)
		
func start_poison(new_damage : float, duration : float):
	is_poisoned = true
	$AnimatedSprite2D.modulate = "d800da"
	#if there is new poison effect we overwrite the damage,
	#otherwise we just extend the existing 
	#maybe change to > instead of != ?
	if poison_damage != new_damage:
		poison_damage = new_damage
		$PoisonTimer.start(1)
	poison_ticks_left = duration
	
func take_poison_damage():
	if poison_ticks_left > 0:
		take_damage(poison_damage, Vector2.ZERO, 0, false)
		poison_ticks_left -= 1
	else:
		is_poisoned = false
		$AnimatedSprite2D.modulate = "ffffff"
		$PoisonTimer.stop()
		
func handle_chain_lightning_logic():
	$ChainLightningAnimation.set_process(true)
	$ChainLightningShapeCast.enabled = true
	$ChainLightningAnimation.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	await(get_tree().create_timer(.1).timeout)
	
	
	$ChainLightningShapeCast.shape.radius = PlayerState.chain_lightning_range
	# to niżej musi być poza ifem jakoś
	PlayerState.start_chain_lightning_timer()
	if not PlayerState.enemies_hit_by_chain_lightning.has(self):
		if PlayerState.enemies_hit_by_chain_lightning.size() == 0:
			PlayerState.first_enemy_hit_name = name
		PlayerState.enemies_hit_by_chain_lightning.append(self)
	else:
		pass
	for index in $ChainLightningShapeCast.get_collision_count():
		if index >= $ChainLightningShapeCast.get_collision_count():
			continue
		var enemy = $ChainLightningShapeCast.get_collider(index)
		if enemy != null and not PlayerState.enemies_hit_by_chain_lightning.has(enemy):
			if PlayerState.enemies_hit_by_chain_lightning.size() <= PlayerState.chain_lightning_max_hits and PlayerState.chain_lightning_ready:
				$ChainLightningAnimation.animate_chain_lightning(global_position, enemy.global_position)
				await(get_tree().create_timer(.1).timeout)
				if is_instance_valid(enemy):
					enemy.take_damage(PlayerState.chain_lightning_damage, Vector2.ZERO, 0, false, false)
				pass
			else:
				PlayerState.chain_lightning_current_hits = 0
				PlayerState.clear_enemies_chain_lightning()
		# kiedy nie ma wystarczasjąco przeciwników tez ma działać
		pass
	if PlayerState.first_enemy_hit_name == name:
		PlayerState.clear_enemies_chain_lightning()
	$ChainLightningAnimation.set_process(false)
	$ChainLightningShapeCast.set_deferred("enabled", false)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	_on_animation_finished($AnimatedSprite2D.animation)
	#if $AnimatedSprite2D.animation == "die":
		#if PlayerState.experience_pickup_bench.size() != 0:
			#var experience_pickup_new = PlayerState.experience_pickup_bench.pop_front()
			#experience_pickup_new.reset(global_position)
		#$Control.global_position = global_position
		##experience_pickup_new.turn_on_collision()
		##experience_pickup_new.global_position = global_position
		##experience_pickup_new.player = null
		##experience_pickup_new.active = true
		##experience_pickup_new.speed = 10000
		##PlayerState.active_enemies_count -= 2
		#PlayerState.coins_base += money
		#reset_enemy()
	is_jumping = false
	$AnimatedSprite2D.play("idle_down")
	
func _on_animation_finished(anim_name : StringName):
	if anim_name == "die":
		if PlayerState.experience_pickup_bench.size() != 0:
			var experience_pickup_new = PlayerState.experience_pickup_bench.pop_front()
			experience_pickup_new.reset(global_position)
		$Control.global_position = global_position
		#experience_pickup_new.turn_on_collision()
		#experience_pickup_new.global_position = global_position
		#experience_pickup_new.player = null
		#experience_pickup_new.active = true
		#experience_pickup_new.speed = 10000
		#PlayerState.active_enemies_count -= 2
		PlayerState.coins_base += money
		reset_enemy()
	is_jumping = false
	$AnimatedSprite2D.play("idle_down")
	
	
func reset_enemy():
	PlayerState.active_enemies_count -= 1
	speed = 0
	global_position = Vector2(-1000,1000)
	for property in get_children():
		if property is Timer:
			continue
		property.global_position = global_position
	PlayerState.enemy_bench.append(self)
	
func spawn_enemy(spawn_position : Vector2):
	active = true
	PlayerState.active_enemies_count += 1
	speed = 75
	healthbar_new.init_health(max_health)
	$Control/Label.text = test_name

	
	@warning_ignore("integer_division")
	max_health += player.get_elapsed_time() / 10
	health = max_health
	global_position = spawn_position
	for property in get_children():
		if property is Timer:
			continue
		property.global_position = global_position
		
func boids():
	if boids_i_see:
		var num_of_boids := boids_i_see.size()
		var avg_velocity := Vector2.ZERO
		var avg_position := Vector2.ZERO
		var steer_away := Vector2.ZERO
		for boid in boids_i_see:
			avg_velocity += boid.velocity
			avg_position += boid.position
			steer_away -= (boid.global_position - global_position) * (movv/(global_position - boid.global_position).length())
			
		avg_velocity /= num_of_boids
		velocity += (avg_velocity - velocity)/2
		
		avg_position /= num_of_boids
		velocity += (avg_position - position)
		
		steer_away /= num_of_boids
		velocity += steer_away
		
	
func check_collisions():
	if boids_i_see.size() == 0:
		return
	var closest_boid : Enemy
	var closest_distance : float = 10000
	var current_distance : float
	for boid in boids_i_see:
		current_distance = global_position.distance_squared_to(boid.global_position)
		if current_distance < closest_distance:
			closest_distance = current_distance
			closest_boid = boid
		
	if closest_boid == null:
		return
	var repulsion_direction : Vector2 = global_position.direction_to(closest_boid.global_position)

	closest_boid.global_position += repulsion_direction * 5

func change_color(_color : Color):
	color = _color
	#$AnimatedSprite2D.modulate = color


func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("boid"):
		boids_i_see.append(area.owner)


func _on_vision_area_exited(area: Area2D) -> void:
	#if boids_i_see.has(area.owner):
		#boids_i_see.erase(area.owner)
	if area:
		boids_i_see.erase(area.owner)
