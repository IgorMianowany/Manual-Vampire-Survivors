class_name Projectile
extends Node2D

@export var speed := 300
@export var lifetime := 3
@export var damage := 1
@export var pierce : int = 0
var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	look_at(position + direction)
	$ArrowHitbox.damage = damage
	$ArrowHitbox.max_hits = pierce
	$Timer.start(lifetime)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()



func _on_arrow_impact_detector_area_entered(area: Area2D) -> void:
	if $ArrowHitbox.hits >= $ArrowHitbox.max_hits - 1:
		queue_free()
