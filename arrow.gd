class_name Projectile
extends Node2D

@export var speed := 300
@export var lifetime := 10
@export var damage := 1
var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	look_at(position + direction)
	$ArrowHitbox.damage = damage
	$Timer.start(lifetime)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()



func _on_arrow_impact_detector_area_entered(area: Area2D) -> void:
	print(area.name)
	await(get_tree().create_timer(.01).timeout)
	queue_free()
