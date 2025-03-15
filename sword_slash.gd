class_name SwordSlash
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
	$SlashHitbox.damage = damage
	$SlashHitbox.max_hits = 1
	$SlashHitbox.is_player_hitbox = true
	$Timer.start(lifetime)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()


@warning_ignore("unused_parameter")
func _on_slash_impact_detector_area_entered(area: Area2D) -> void:
	if $SlashHitbox.hits >= $SlashHitbox.max_hits - 1:
		queue_free()

func _on_slash_impact_detector_body_entered(body: Node2D) -> void:
	print(body.name)
