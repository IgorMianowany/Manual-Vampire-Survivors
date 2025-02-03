class_name Projectile
extends Node2D

@export var speed : float
@export var lifetime : float
@export var max_homing_speed : float = 0.7 

var damage : float
var pierce : int
var direction := Vector2.ZERO
var target : CharacterBody2D
var prev_pos : Vector2
var current_pos : Vector2 = Vector2.ZERO
var crit_chance : float
var crit_multi : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	look_at(position + direction)
	speed = PlayerState.projectile_speed
	lifetime = PlayerState.projectile_lifetime
	$ProjectileHitbox.damage = damage
	$ProjectileHitbox.max_hits = pierce # nic nie daje
	$ProjectileHitbox.is_player_hitbox = true
	$ProjectileHitbox.crit_chance = crit_chance
	$ProjectileHitbox.crit_multi = crit_multi
	$Timer.start(lifetime)

func _physics_process(delta: float) -> void:
	prev_pos = current_pos
	current_pos = global_position
	#print((prev_pos-current_pos).length())
	if target != null and PlayerState.has_homing_projectiles:
		direction += (global_position.direction_to(target.global_position)/5)
	rotation = direction.angle()
	direction = direction.clamp(Vector2(-max_homing_speed,-max_homing_speed), Vector2(max_homing_speed, max_homing_speed))
	position += direction * speed * delta
	if $ProjectileHitbox.hits >= $ProjectileHitbox.max_hits:
		_on_projectile_death()
	


func _on_timer_timeout() -> void:
	queue_free()


@warning_ignore("unused_parameter")
func _on_projectile_impact_detector_area_entered(area: Area2D) -> void:
	if area.name != $ProjectileImpactDetector.name:
		if $ProjectileHitbox.hits >= $ProjectileHitbox.max_hits - 1:
			_on_projectile_death()

func _on_projectile_impact_detector_body_entered(body: Node2D) -> void:
	if body.name != $ProjectileImpactDetector.name:
		_on_projectile_death()

func _on_projectile_death():
	queue_free()

#func _on_arrow_hitbox_area_entered(area: Area2D) -> void:
	#print(area.name)
	#if area.name != $ArrowImpactDetector.name:
		#if $ArrowHitbox.hits >= $ArrowHitbox.max_hits - 1:
			#queue_free()
#
#
#func _on_arrow_hitbox_body_entered(body: Node2D) -> void:
	#print(body.name)
	#if body.name != $ArrowImpactDetector.name:
		#if $ArrowHitbox.hits >= $ArrowHitbox.max_hits - 1:
			#queue_free()



func _on_homing_range_body_entered(body: Node2D) -> void:
	if target == null:
		target = body
