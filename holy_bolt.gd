extends Node2D

var cost : float
var damage : float
var speed : float
var velocity : Vector2
var direction : Vector2
var lifetime : float = 3

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	global_position += velocity * delta
	

func _ready() -> void:
	velocity = direction * speed
	$Hitbox.damage = damage
