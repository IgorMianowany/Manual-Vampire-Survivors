extends Node

var max_health : float = 100
var experience : int = 0
var experience_threshold : int = 1
var level : int = 0
var projectiles : int = 0
var attack_speed : float = .5
var attack_damage : float = 5
var movespeed_bonus : float = 0
var chosen_class : int = 0
var jim_beam_counter : int = 0
@onready var health : float = max_health

enum UPGRADES {ATTACK_SPEED, ATTACK_DAMAGE, PROJECTILES, HEALTH, MOVESPEED, MISC}

var debug_value : int = 0

signal level_up
signal after_level_up
signal after_class_chosen
	
func add_exp(exp_amount : int) -> void:
	experience += exp_amount
	if experience >= experience_threshold:
		level += 1
		experience = experience % experience_threshold
		experience_threshold += 0
		level_up.emit()
		
@warning_ignore("unused_parameter")
func add_upgrade(upgrade : UPGRADES, upgrade_number : int):
	if upgrade == UPGRADES.ATTACK_SPEED:
		attack_speed -= 0.5 * attack_speed
	elif upgrade == UPGRADES.ATTACK_DAMAGE:
		attack_damage += 5
	elif upgrade == UPGRADES.PROJECTILES:
		projectiles += 1
	elif upgrade == UPGRADES.HEALTH:
		max_health += 100
	elif upgrade == UPGRADES.MOVESPEED:
		movespeed_bonus += 1000
	else:
		debug_value += 1
		
	health = max_health

	after_level_up.emit()

func choose_class(class_number : int):
	chosen_class = class_number
	after_class_chosen.emit()
	
