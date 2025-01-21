class_name WeaponType
extends Node2D

var pierce : int
var projectiles : int

@warning_ignore("unused_signal")
signal attack_started
@warning_ignore("unused_signal")
signal attack_finished

@warning_ignore("unused_parameter")
func attack(damage : float, attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	print("default weapon type attack")
