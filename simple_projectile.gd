class_name SimpleProjectile
extends Node2D

@export var speed : float = 100
@export var lifetime : float = 2

var damage : float
var direction := Vector2.ZERO
var velocity : Vector2
var active : bool = false

func _ready() -> void:
	set_as_top_level(true)
	set_process(false)
	$Timer.wait_time = lifetime
	$Timer.autostart = true

func _physics_process(delta: float) -> void:
	if not active:
		return
	velocity = direction * speed * delta
	global_position += velocity


func _on_timer_timeout() -> void:
	_on_projectile_death()

@warning_ignore("unused_parameter")
func _on_projectile_impact_detector_area_entered(area: Area2D) -> void:
	if area.name != $ProjectileImpactDetector.name:
		_on_projectile_death()

func _on_projectile_impact_detector_body_entered(body: Node2D) -> void:
	if body.name != $ProjectileImpactDetector.name:
		_on_projectile_death()

func _on_projectile_death():
	set_process(false)
	active = false
	PlayerState.enemy_projectile_bench.append(self)
	global_position = Vector2(-10000,-10000)
		
func _reusable_ready():
	look_at(global_position + direction)
	set_process(true)
	speed = PlayerState.projectile_speed
	lifetime = PlayerState.projectile_lifetime
	$ProjectileHitbox.hits = 0
	$ProjectileHitbox.damage = damage
	$ProjectileHitbox.is_player_hitbox = false
	$Timer.start(lifetime)
