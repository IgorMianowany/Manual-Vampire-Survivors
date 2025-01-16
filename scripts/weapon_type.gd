class_name WeaponType
extends Node2D

var pierce : int
var projectiles : int

signal attack_started
signal attack_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(damage : float, position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	print("default weapon type attack")
