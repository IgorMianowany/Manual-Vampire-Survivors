class_name LightEnemy
extends Area2D
var velocity : Vector2
var speed : float = 500
var direction : Vector2

func _process(delta: float) -> void:
	direction = global_position.direction_to(PlayerState.player_position)
	velocity = direction * speed * delta
	global_position += velocity.normalized()
