class_name Fireball
extends Node2D

@export var speed := 300
@export var lifetime := 3
var damage : float
var pierce : int
var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	look_at(position + direction)
	$FireballHitbox.damage = damage
	$FireballHitbox.max_hits = pierce
	$FireballHitbox.is_player_hitbox = true
	$FireballExplosionRadius.monitoring = false
	$Timer.start(lifetime)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if $FireballHitbox.hits >= $FireballHitbox.max_hits:
		fireball_end_of_life()

func _on_timer_timeout() -> void:
	fireball_end_of_life()



@warning_ignore("unused_parameter")
func _on_fireball_impact_detector_area_entered(area: Area2D) -> void:
	if area.name != $FireballImpactDetector.name:
		if $FireballHitbox.hits >= $FireballHitbox.max_hits - 1:
			fireball_end_of_life()

func _on_fireball_impact_detector_body_entered(body: Node2D) -> void:
	if body.name != $FireballImpactDetector.name:
		fireball_end_of_life()
	
func animate_explosion():
	$FireballExplosionRadius.monitoring = true
	speed = 0
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		$Sprite2D, "scale", Vector2(2, 5), .2
	)
	await tween.finished
	queue_free()
	


func _on_fireball_explosion_radius_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage, global_position.direction_to(area.global_position), 2, PlayerState.has_poison_attacks)
		
func fireball_end_of_life():
	animate_explosion()
