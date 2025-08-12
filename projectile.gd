class_name Projectile
extends Node2D

@export var speed : float = 100
@export var lifetime : float = 3
@export var max_homing_speed : float = 0.7 

var damage : float
var max_speed : float = 4
var pierce : int
var direction := Vector2.ZERO
var target : CharacterBody2D
var prev_pos : Vector2
var current_pos : Vector2 = Vector2.ZERO
var crit_chance : float
var crit_multi : float
var current_speed : float
var velocity : Vector2
var active : bool = false
var start_position : Vector2
var player_projectile : bool = true

func _ready() -> void:
	set_as_top_level(true)
	set_process(false)
	$Timer.wait_time = lifetime
	$Timer.autostart = true

func _physics_process(delta: float) -> void:
	if not active:
		return
	if not player_projectile:
		velocity = direction * (speed / 2) * delta
		global_position += velocity
		return
	PlayerState.max_projectile_speed = 2
	prev_pos = current_pos
	current_pos = global_position
	current_speed = (prev_pos - current_pos).length()
	if not PlayerState.has_homing_projectiles and current_speed < PlayerState.max_projectile_speed and current_speed != 0:
		PlayerState.max_projectile_speed = current_speed

	if PlayerState.has_homing_projectiles and PlayerState.projectile_lifetime - $Timer.time_left > 0.1:
		if target != null and (target as Slime).health > 0:
			direction += (global_position.direction_to(target.global_position)/5)
			#max_homing_speed -= (100 - min(100, global_position.distance_to(target.global_position)))/100
			rotation = direction.angle()
		elif target != null and (target as Slime).health <= 0:
			target = null
			$HomingRange/CollisionShape2D.set_deferred("disabled", false)
	#if target != null and (target as Slime).health > 0 and PlayerState.has_homing_projectiles and PlayerState.projectile_lifetime - $Timer.time_left > 0.1:
		#direction += (global_position.direction_to(target.global_position)/5)
		##max_homing_speed -= (100 - min(100, global_position.distance_to(target.global_position)))/100
		#rotation = direction.angle()
	#else if target != null and (target as Slime)
	direction = direction.clamp(Vector2(-max_homing_speed,-max_homing_speed), Vector2(max_homing_speed, max_homing_speed))
	velocity = direction * speed * delta
	if velocity.length() > PlayerState.max_projectile_speed:
		velocity = velocity.normalized() * PlayerState.max_projectile_speed
	global_position += velocity
	#if current_speed > max_speed:
		#position = position.normalized() * max_speed
	#TODO ogarnąć zcy to ma sens
	#if $ProjectileHitbox.hits >= $ProjectileHitbox.max_hits:
		#_on_projectile_death()
	


func _on_timer_timeout() -> void:
	_on_projectile_death()

@warning_ignore("unused_parameter")
func _on_projectile_impact_detector_area_entered(area: Area2D) -> void:
	if area.name != $ProjectileImpactDetector.name:
		if $ProjectileHitbox.hits >= $ProjectileHitbox.max_hits - 1:
			_on_projectile_death()

func _on_projectile_impact_detector_body_entered(body: Node2D) -> void:
	if body.name != $ProjectileImpactDetector.name and body.name != "Slime" and body.name != "SkeletonArcher" and body.name != "Player":
		_on_projectile_death()

func _on_projectile_death():
	set_process(false)
	change_target(false)
	player_projectile = true
	active = false
	PlayerState.projectile_bench.append(self)
	global_position = Vector2(1000,-1000)
#func _on_arrow_hitbox_area_entered(area: Area2D) -> void:
	#print(area.name)
	#if area.name != $ArrowImpactDetector.name:
		#if $ArrowHitbox.hits >= $ArrowHitbox.max_hits - 1:
			#queue_free()

#
#func _on_arrow_hitbox_body_entered(body: Node2D) -> void:
	#print(body.name)
	#if body.name != $ArrowImpactDetector.name:
		#if $ArrowHitbox.hits >= $ArrowHitbox.max_hits - 1:
			#queue_free()



func _on_homing_range_body_entered(body: Node2D) -> void:
	if target == null:
		target = body
		$HomingRange/CollisionShape2D.set_deferred("disabled", true)
		
		
func _reusable_ready():
	look_at(global_position + direction)
	set_process(true)
	target = null
	speed = PlayerState.projectile_speed
	lifetime = PlayerState.projectile_lifetime
	$ProjectileHitbox.hits = 0
	$ProjectileHitbox.damage = damage
	$ProjectileHitbox.max_hits = pierce # nic nie daje
	$ProjectileHitbox.is_player_hitbox = true
	$ProjectileHitbox.crit_chance = crit_chance
	$ProjectileHitbox.crit_multi = crit_multi
	$HomingRange/CollisionShape2D.set_deferred("disabled", false)
	$Timer.start(lifetime)

	
func change_target(is_target_player : bool):
	if is_target_player:
		$ProjectileHitbox.collision_layer = 32
		$ProjectileImpactDetector.collision_mask = 11
	else:
		$ProjectileHitbox.collision_layer = 16
		$ProjectileImpactDetector.collision_mask = 7


func _on_projectile_impact_detector_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print(PhysicsServer2D.body_get_collision_layer(body_rid))
	_on_projectile_death()
