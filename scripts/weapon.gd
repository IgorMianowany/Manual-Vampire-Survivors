class_name Weapon
extends Node2D

@export var weapon_type : WeaponType
@export var damage : float
@export var pierce : int = 1
@export var crit_chance : float = 0.1
@export var crit_multi : float = 1
@export var projectiles : int = 1
var is_attacking = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sword.crit_chance = crit_chance
	$Sword.crit_multi = crit_multi
	is_attacking = false

	

func attack(attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	if not is_attacking:
		# reset max projectile speed so it can be overwritten
		PlayerState.max_projectile_speed = 4
		weapon_type.pierce = pierce + PlayerState.pierce
		weapon_type.projectiles = projectiles + PlayerState.projectiles
		weapon_type.attack(damage, attack_position, direction, crit_chance + PlayerState.critical_strike_chance_bonus, crit_multi)


func _on_bow_attack_started() -> void:
	is_attacking = true


func _on_bow_attack_finished() -> void:
	is_attacking = false


func _on_sword_attack_finished() -> void:
	is_attacking = false


func _on_sword_attack_started() -> void:
	is_attacking = true


func _on_staff_attack_finished() -> void:
	is_attacking = false


func _on_staff_attack_started() -> void:
	is_attacking = true
