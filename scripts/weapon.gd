class_name Weapon
extends Node2D

@export var weapon_type : WeaponType

var is_attacking
var damage : float = 4



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func attack() -> void:
	weapon_type.attack(damage)
