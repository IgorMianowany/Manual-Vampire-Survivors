class_name Hitbox
extends Area2D

var damage : float = 10
var knockback_power : float = 1
var hits : int = 0
var max_hits : int = 1
#var list_of_enemies : Array[Slime]


func _init() -> void:
	collision_layer = 16
	collision_mask = 0
