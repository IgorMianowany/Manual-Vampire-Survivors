class_name BossProjectile
extends Node2D

var speed : float = 50
var direction : Vector2
var body

func _ready() -> void:
	set_as_top_level(true)

func _process(delta: float) -> void:
	$Sprite2D.rotate(0.01)

func _physics_process(delta: float) -> void:
	global_position = global_position + direction * speed * delta
