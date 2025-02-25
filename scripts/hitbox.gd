class_name Hitbox
extends Area2D

@export var damage : float = 10
var crit_chance : float = 0
var crit_multi : float = 0
var knockback_power : float = 1
var hits : int = 0
var max_hits : int = 10000000
var is_poisoning : bool 
var is_player_hitbox : bool = false
var hitbox_name : String = "Hitbox"


func _init() -> void:
	collision_layer = 16
	collision_mask = 0

func is_crit() -> bool:
	return randf_range(0,1) < crit_chance
	
