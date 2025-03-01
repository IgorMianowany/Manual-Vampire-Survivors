extends Node

@onready var health : float = max_health : get = get_current_health
var max_health_bonus : float = 0	
var max_health_base : float = 10
var max_health : get = get_max_health
var experience : int = 0
var experience_threshold : get = get_experience_threshold
var experience_threshold_base : int = 1
var experience_threshold_bonus : int = 0
var level : int = 0
var projectiles : int = 0
var projectile_speed : get = get_projectile_speed
var projectile_speed_bonus : float = 0
var projectile_speed_base : float = 300
var projectile_lifetime : float = 3
var pierce : int = 0
var attack_speed_base : float = 1
var attack_speed : get = get_attack_speed
var attack_speed_bonus : float = 0
var attack_damage : float : get = get_attack_damage
var attack_damage_base : float = 5
var attack_damage_bonus : float = 0
var movespeed_bonus : float = 0
var movespeed_base : float = 100
var movespeed : get = get_movement_speed
var chosen_class : int = -1
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
var lightning_strike_cooldown = 0
var lightning_strike_damage = 0
var lightning_strike_range = 0
var slime_count = 0
var has_knife : bool = false
var max_projectile_speed : float = 4
var final_score : int = 0
var health_bonus_per_jim_beam = 50
var upgrades_amount : get = get_upgrades_amount
var upgrades_amount_base : int = 0
var upgrades_amount_bonus : int = 30000
var coins_base : int = 0
var stats_not_displayable : Array[String] = ["chosen_class", "first_enemy_hit_name", "has_dash", "chain_lightning_current_hits", "chain_lightning_ready",
"has_homing_projectiles", "has_bubble_shield_upgrade", "mana_regen_blocked", "has_poison_attacks", "stats_not_displayable", "has_chain_lightning", "enemies_hit_by_chain_lightning",
"debug_value", "max_projectile_speed", "final_score", "health_bonus_per_jim_beam"]
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
@warning_ignore("unused_signal")
signal player_death

func get_max_health() -> float:
	return max_health_base + max_health_bonus + jim_beam_counter * health_bonus_per_jim_beam

func set_max_health(new_value):
	var health_percantage = health / max_health
	max_health_bonus += new_value
	health = int(max_health * health_percantage)

func get_current_health() -> float:
	return clampf(health, health, max_health)
	
func heal(heal_amount):
	health = clampf(health + heal_amount, 1, max_health)

func get_attack_damage() -> float:
	return (attack_damage_base + attack_damage_bonus) * get_jim_beam_attack_bonus()
	
func get_jim_beam_attack_bonus() -> float:
	return pow(2, jim_beam_counter)

func set_attack_damage(new_value):
	attack_damage_bonus += new_value

func get_movement_speed() -> float:
	return movespeed_base + movespeed_bonus
	
func get_attack_speed() -> float:
	return attack_speed_base - attack_speed_bonus
	
func get_projectile_speed() -> float:
	return projectile_speed_base + projectile_speed_bonus

func set_projectile_speed(new_value):
	projectile_speed_bonus += new_value
	
func get_experience_threshold() -> int:
	return experience_threshold_base + experience_threshold_bonus
	
func get_upgrades_amount() -> int:
	return upgrades_amount_base + upgrades_amount_bonus
	
func set_upgrades_amount(new_value):
	upgrades_amount_bonus = clampi(new_value, 1, 3000)

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
		experience_threshold_bonus += 0
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
		
	#health = max_health
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
		if propertyName.contains("timer") or propertyName.contains("bonus") or propertyName.contains("base") or stats_not_displayable.has(propertyName):
			continue
		var new_property_name = turn_snake_case_to_name(propertyName)
		var propertyValue = get(propertyName)
		if not propertyValue:
			continue
		if propertyValue == 0 and propertyName != "health":
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
	var chance_to_puke = 0.1 * jim_beam_counter
	var puke_roll = randf_range(0,1)
	if puke_roll < chance_to_puke:
		puke.emit()
		jim_beam_counter = 0
		return
	heal(health_bonus_per_jim_beam)

func add_lightning_strike_item():
	if lightning_strike_cooldown == 0:
		lightning_strike_cooldown = 9.5
		lightning_strike_damage = 5
		lightning_strike_range = 100
	if lightning_strike_cooldown < 1:
		lightning_strike_cooldown = 0.5
		
	add_lightning_strike.emit()
	
	
func reset_bonus_stats():
	var thisScript: GDScript = get_script()
	for propertyInfo in thisScript.get_script_property_list():
		var propertyName: String = propertyInfo.name
		if propertyName.contains("timer") or propertyName.contains("base") or propertyName == "stats_not_displayable":
			continue
		var propertyValue = get(propertyName)
		if propertyName == "chosen_class":
			set(propertyName, -1)
		elif typeof(propertyValue) == TYPE_BOOL:
			set(propertyName, false)
		elif typeof(propertyValue) == TYPE_FLOAT or typeof(propertyValue) == TYPE_INT:
			set(propertyName, 0)
		elif typeof(propertyValue) == TYPE_ARRAY:
			set(propertyName, [])
