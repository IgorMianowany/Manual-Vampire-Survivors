extends Node

var max_health : float = 100
var experience : int = 0
var experience_threshold : int = 10
var level : int = 0
var projectiles : int = 0
var attack_speed : float = 1
var attack_damage : float = 5
@onready var health : float = max_health

enum UPGRADES {ATTACK_SPEED, ATTACK_DAMAGE, PROJECTILES}

var debug_value : int = 0

signal death
signal level_up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_exp(exp : int) -> void:
	experience += exp
	if experience >= experience_threshold:
		level += 1
		experience = experience % experience_threshold
		experience_threshold += 5
		level_up.emit()
		
func add_upgrade(upgrade : UPGRADES, upgrade_number : int):
	if upgrade == UPGRADES.ATTACK_SPEED:
		attack_speed -= 0.1 * attack_speed
		print(attack_speed)
	elif upgrade == UPGRADES.ATTACK_DAMAGE:
		attack_damage += 5
	elif upgrade == UPGRADES.PROJECTILES:
		projectiles += 1
		
