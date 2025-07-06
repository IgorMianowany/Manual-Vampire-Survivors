class_name LightEnemy
extends CharacterBody2D



#var velocity : Vector2
@export var speed : float
var direction : Vector2
var variation : Vector2
var range : float = 1

func _ready() -> void:
	speed = 50
	speed += randf_range(-25, 25)
	variation = Vector2(randf_range(-range, range), randf_range(-range, range))

func _process(delta: float) -> void:
	direction = global_position.direction_to(PlayerState.player_position)
	velocity = direction.normalized() * speed * delta
	#velocity += Vector2(randf_range(-range, range), randf_range(-range, range))
	#global_position += velocity
	move_and_collide(velocity)
