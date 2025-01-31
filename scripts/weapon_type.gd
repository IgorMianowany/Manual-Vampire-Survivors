class_name WeaponType
extends Node2D

var pierce : int
var projectiles : int
var rotation_change := 0
@export var spread := 30 # make spread based on projectile number, maybe something like 30 degrees + int division of projectiles * 10, so 10 degrees for every 5 projectiles for example
@export var weapon_texture : Texture2D

@warning_ignore("unused_signal")
signal attack_started
@warning_ignore("unused_signal")
signal attack_finished

@warning_ignore("unused_parameter")
func attack(damage : float, attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	print("default weapon type attack")
