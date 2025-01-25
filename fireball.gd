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
	$FireballHitbox.max_hits = 1
	$Timer.start(lifetime)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()


@warning_ignore("unused_parameter")
func _on_fireball_impact_detector_area_entered(area: Area2D) -> void:
	if area.name != $FireballImpactDetector.name:
		if $FireballHitbox.hits >= $FireballHitbox.max_hits - 1:
			animate_explosion()


func _on_fireball_impact_detector_body_entered(body: Node2D) -> void:
	if body.name != $FireballImpactDetector.name:
		animate_explosion()
	
func animate_explosion():
	speed = 0
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		$Sprite2D, "scale", Vector2(2, 5), .2
	)
	await tween.finished
	queue_free()
	


func _on_fireball_explosion_radius_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
