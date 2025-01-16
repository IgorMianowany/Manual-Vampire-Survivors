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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if not list_of_enemies.is_empty():
		#print(str(list_of_enemies))
