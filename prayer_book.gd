class_name PrayerBook
extends WeaponType
var attack_time : float = .5
var knockback_power : float = 1
var timer : Timer
var slash_scene := preload("res://sword_slash_new.tscn")
var sword_projectiles : int
var crit_chance : float
var crit_multi : float
@export var attack_range_pointer : Node2D
@export var attack_shape_cast : ShapeCast2D
@export var hitbox : Hitbox
@export var hitboxShape : CollisionShape2D

func attack(_attack_damage : float, _attack_position : Vector2 = Vector2.ZERO, _direction : Vector2 = Vector2.ZERO, _crit_chance_from_weapon : float = 0, _crit_multi_from_weapon : float = 0) -> void:
	attack_started.emit()
	await(get_tree().create_timer(attack_time).timeout)
	attack_finished.emit()
