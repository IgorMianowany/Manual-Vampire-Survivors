extends Node

var max_health : float = 100
var experience : int = 0
var experience_threshold : int = 1
var level : int = 0
var projectiles : int = 0
var projectile_speed : float = 300
var projectile_lifetime : float = 3
var pierce : int = 0
var attack_speed : float = .5
var attack_damage : float = 5
var movespeed_bonus : float = 0
var chosen_class : int = 0
var jim_beam_counter : int = 0
var palladin_hammer_counter : int = 0
var palladin_hammer_damage : float = 0
var palladin_hammer_speed : float = 0
var has_poison_attacks : bool = false
var poison_damage : float = 0
var poison_duration : float = 0
var knockback_bonus : float = 0
var max_mana : float = 0
var mana_regen_blocked : bool = false
var bubble_shield_cooldown : float
var bubble_shield_max_hits : float = 0
var has_bubble_shield_upgrade : bool
var has_homing_projectiles : bool = false
var critical_strike_chance_bonus : float = 0
var critical_strike_damage_bonus : float = 0
var has_chain_lightning : bool = false
var chain_lightning_ready : bool = false
# base range and all is set in "get_chain_lightning"
var chain_lightning_range : float = 0
var chain_lightning_damage : float = 0
var chain_lightning_max_hits : int = 0
var chain_lightning_current_hits : int = 0
var chain_lightning_cooldown : float = 0
var enemies_hit_by_chain_lightning : Array[Slime]
var view_distance_bonus : float = 0
var chain_lightning_timer : Timer = Timer.new()
var first_enemy_hit_name : String
var has_dash : bool = false
var dash_cooldown : float = 0
var dash_damage : float = 0
var dash_timer : Timer = Timer.new()
var jim_beam_multi = 0
var lightning_strike_cooldown = 0
var lightning_strike_damage = 0
var lightning_strike_range = 0
var slime_count = 0
var has_knife : bool = false
@onready var upgrades_amount : int = 3000
var stats_not_displayable : Array[String] = ["chosen_class", "first_enemy_hit_name", "has_dash", "chain_lightning_current_hits", "chain_lightning_ready",
"has_homing_projectiles", "has_bubble_shield_upgrade", "mana_regen_blocked", "has_poison_attacks", "stats_not_displayable", "has_chain_lightning", "enemies_hit_by_chain_lightning",
"debug_value"]
@onready var health : float = max_health
@onready var mana : float = max_mana

enum UPGRADES {ATTACK_SPEED, ATTACK_DAMAGE, PROJECTILES, HEALTH, MOVESPEED, MISC}

var debug_value : int = 0

signal level_up
signal after_level_up
signal after_class_chosen
@warning_ignore("unused_signal")
signal add_palladin_hammer
@warning_ignore("unused_signal")
signal add_bubble_shield
signal add_lightning_strike
signal jim_beam_drank
signal puke
@warning_ignore("unused_signal")
signal add_knife

func _ready() -> void:
	add_child(chain_lightning_timer)
	add_child(dash_timer)
	chain_lightning_timer.autostart = false
	chain_lightning_timer.timeout.connect(on_chain_lightning_timer_timeout)
	dash_timer.timeout.connect(on_dash_timer_timeout)
	jim_beam_drank.connect(handle_jim_beam_drank)
	
func _physics_process(_delta: float) -> void:
	if mana < max_mana and not mana_regen_blocked:
		mana += 0.05
	
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
	
func clear_enemies_chain_lightning():
	if not chain_lightning_ready:
		return
	chain_lightning_ready = false
	await(get_tree().create_timer(chain_lightning_cooldown).timeout)
	#for enemy in enemies_hit_by_chain_lightning:
		#if enemy != null:
			#enemy.already_hit_by_chain_lightning = false
	enemies_hit_by_chain_lightning.clear()
	chain_lightning_ready = true
	
func get_chain_lightning():
	if not has_chain_lightning:
		has_chain_lightning = true
		chain_lightning_ready = true
		chain_lightning_range = 50
		chain_lightning_max_hits = 2
		chain_lightning_cooldown = 5
		
func start_chain_lightning_timer():
	chain_lightning_timer.wait_time = chain_lightning_cooldown
	chain_lightning_timer.start()
	
func on_chain_lightning_timer_timeout():
	chain_lightning_timer.stop()

func on_dash_timer_timeout():
	dash_timer.stop()
	
func get_first_vbox_stats() -> Array[String]:
	var thisScript: GDScript = get_script()
	var stat_array : Array[String]
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		if propertyName.contains("timer") or stats_not_displayable.has(propertyName):
			continue
		var new_property_name = turn_snake_case_to_name(propertyName)
		var propertyValue = get(propertyName)
		if not propertyValue:
			continue
		if propertyValue == 0:
			continue
		if propertyValue != null:
			stat_array.append(new_property_name + ": " + str(propertyValue))
	return stat_array
	
func turn_snake_case_to_name(string : String) -> String:
	for index in string.length():
		if index == 0:
			string[0] = string[0].to_upper()
		if string[index] == "_":
			string[index] = " "
			string[index + 1] = string[index + 1].to_upper()
	return string
	
func handle_jim_beam_drank():
	if jim_beam_multi == 0:
		jim_beam_multi = 1
	var old_attack_damage = attack_damage / jim_beam_multi
	jim_beam_multi += 1
	attack_damage = old_attack_damage * jim_beam_multi
	var chance_to_puke = 0.1 * jim_beam_counter
	var puke_roll = randf_range(0,1)
	if puke_roll < chance_to_puke:
		puke.emit()
		jim_beam_counter = 0
		
func add_lightning_strike_item():
	if lightning_strike_cooldown == 0:
		lightning_strike_cooldown = 9.5
		lightning_strike_damage = 5
		lightning_strike_range = 100
	if lightning_strike_cooldown < 1:
		lightning_strike_cooldown = 0.5
	add_lightning_strike.emit()

	
	
	
