class_name Weapon
extends Node2D

@export var weapon_type : WeaponType
@export var damage : float
@export var pierce : int = 1
@export var projectiles : int = 1
var is_attacking = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	

func attack(position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	if not is_attacking:
		weapon_type.pierce = pierce
		weapon_type.projectiles = projectiles + PlayerState.level
		weapon_type.attack(damage, position, direction)



func _on_bow_attack_started() -> void:
	is_attacking = true


func _on_bow_attack_finished() -> void:
	is_attacking = false


func _on_sword_attack_finished() -> void:
	is_attacking = false


func _on_sword_attack_started() -> void:
	is_attacking = true
