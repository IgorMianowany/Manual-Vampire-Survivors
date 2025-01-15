class_name Hitbox
extends Area2D

@export var damage : float = 10
var knockback_power : float = 1


func _init() -> void:
	collision_layer = 16
	collision_mask = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
