extends Node

var health : float : get = get_current_health
var max_health_bonus : float = 0
var max_health_base : float = 100000
var max_health : get = get_max_health
var experience : int = 0
var experience_threshold : get = get_experience_threshold
var experience_threshold_base : int = 10000
var experience_threshold_bonus : int = 0
var level : int = 0
var projectiles : int = 0
var projectile_speed : get = get_projectile_speed
var projectile_speed_bonus : float = 0
var projectile_speed_base : float = 300
var projectile_lifetime : float = 3
var pierce : int = 0
var attack_speed_base : float = .2
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
var active_enemies_count = 0
var slime_spawned = 0
var has_knife : bool = false
var max_projectile_speed : float = .1
var final_score : int = 0
var health_bonus_per_jim_beam = 50
var upgrades_amount : get = get_upgrades_amount
var upgrades_amount_base : int = 3
var upgrades_amount_bonus : int = 0
var coins_base : int = 6000
var ninja_unlocked_base : bool = false
var game_time : float = 0
var slime_scene := preload("res://slime.tscn")
var enemy_bench : Array[Enemy] = []
var experience_pickup := preload("res://experience_pickup.tscn")
var experience_pickup_bench : Array[ExperiencePickup] = []
var projectile_bench : Array[Projectile] = []
var enemy_projectile_bench : Array[SimpleProjectile] = []
var simple_projectile_scene := preload("res://simple_projectile.tscn")
var sword_level_base : int = 1
var staff_level_base : int = 1
var bow_level_base : int = 1
var prayer_book_level_base : int = 1
var class_level : int = 0
var mana_regen_base : float = 0.05
var mana_regen_bonus : float = 0
var faith_base : float = 100
var max_faith : float = 100 : get = get_max_faith
var faith_bonus : float = 0
var faith : float = max_faith
var faith_regen_base : float = 0.05
var faith_regen_bonus : float = 0
var holy_bolt_cooldown_base : float = 1
var holy_explosion_cooldown_base : float = 1
var holy_beam_cooldown_base : float = 1
var stats_not_displayable : Array[String] = ["chosen_class", "first_enemy_hit_name", "has_dash", "chain_lightning_current_hits", "chain_lightning_ready",
"has_homing_projectiles", "has_bubble_shield_upgrade", "mana_regen_blocked", "has_poison_attacks", "stats_not_displayable", "has_chain_lightning", "enemies_hit_by_chain_lightning",
"debug_value", "max_projectile_speed", "final_score", "health_bonus_per_jim_beam", "enemy_bench", "experience_pickup", "experience_pickup_bench", "slime_scene", "simple_projectile_scene", "player_position"]
@onready var mana : float = max_mana
var player_position : Vector2

enum UPGRADES {ATTACK_SPEED, ATTACK_DAMAGE, PROJECTILES, HEALTH, MOVESPEED, SWORD_LEVEL, BOW_LEVEL, STAFF_LEVEL, MISC}

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
	upgrades_amount_bonus = clampi(new_value, 1, 4)
	
func get_game_time() -> int:
	return int(game_time)

func get_max_faith() -> float:
	return faith_base + faith_bonus
	
func _ready() -> void:
	health = max_health
	add_child(chain_lightning_timer)
	add_child(dash_timer)
	chain_lightning_timer.autostart = false
	chain_lightning_timer.timeout.connect(on_chain_lightning_timer_timeout)
	dash_timer.timeout.connect(on_dash_timer_timeout)
	jim_beam_drank.connect(handle_jim_beam_drank)
	#var pickup_holder_node := get_parent().get_child(2).get_child(0).find_child("PickupsHolder")
	#for count in range(0, 100):
		#var experience_pickup_instance = experience_pickup.instantiate()
		#experience_pickup_instance.experience_points = 1
		#pickup_holder_node.add_child(experience_pickup_instance)
		#experience_pickup_bench.append(experience_pickup_instance)
		#experience_pickup_instance.global_position = experience_pickup_instance.get_parent().global_position
	#var enemy_holder_node := get_parent().get_child(2).get_child(0).find_child("EnemyHolder")
	#for slime in range(0,100):
		#var slime_instance = slime_scene.instantiate()
		#enemy_holder_node.add_child(slime_instance)
		#slime_instance.global_position = Vector2.ZERO
		#enemy_bench.append(slime_instance)
		
func _physics_process(_delta: float) -> void:
	game_time += _delta
	if mana < max_mana and not mana_regen_blocked:
		mana += mana_regen_base * staff_level_base
	
func add_exp(exp_amount : int) -> void:
	experience += exp_amount
	if experience >= experience_threshold:
		level += 1
		experience = experience % experience_threshold
		#experience_threshold_bonus += 0
		calculate_experience_threshold()
		level_up.emit()
		
@warning_ignore("unused_parameter")
func add_upgrade(upgrade : UPGRADES, upgrade_number : int):
	if upgrade == UPGRADES.ATTACK_SPEED and get_attack_speed() > 0.1:
		attack_speed_base -= .05
	elif upgrade == UPGRADES.ATTACK_DAMAGE:
		attack_damage_base += 1
	elif upgrade == UPGRADES.HEALTH:
		max_health_base += 5
	elif upgrade == UPGRADES.MOVESPEED:
		movespeed_bonus += 10
	elif upgrade == UPGRADES.STAFF_LEVEL:
		staff_level_base += 1
	else:
		debug_value += 1
		
	#health = max_health
	after_level_up.emit()

func choose_class(class_number : int):
	var arrow_scene := preload("res://arrow.tscn")
	var fireball_scene := preload("res://fireball_new.tscn")
	var projectile_node = get_parent().get_child(2).get_child(0).find_child("ProjectileHolder")
	var simple_projectile : SimpleProjectile
	for i in range(0, 200):
		simple_projectile = simple_projectile_scene.instantiate()
		projectile_node.add_child(simple_projectile)
		enemy_projectile_bench.append(simple_projectile)
		
	chosen_class = class_number
	after_class_chosen.emit()

	if class_number == 1:
		for i in range(0,100):
			var projectile := arrow_scene.instantiate()
			projectile_node.add_child(projectile)
			projectile_bench.append(projectile)
	if class_number == 2:
		if class_level < 10:
			for i in range(0,200):
				var projectile := fireball_scene.instantiate()
				projectile_node.add_child(projectile)
				projectile_bench.append(projectile)
	
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
		if propertyName.contains("timer") or propertyName.contains("bonus") or propertyName.contains("base") or propertyName.contains("bench") or stats_not_displayable.has(propertyName):
			continue
		var new_property_name = turn_snake_case_to_name(propertyName)
		var propertyValue = get(propertyName)
		if not propertyValue:
			continue
		if propertyValue == 0 and propertyName != "health":
			continue
		if propertyValue != null:
			stat_array.append(new_property_name + ": " + str(int(propertyValue)))
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
	#if lightning_strike_cooldown == 0:
		#lightning_strike_cooldown = 9.5
		#lightning_strike_damage = 5
		#lightning_strike_range = 100
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
	projectile_bench = []
	experience_pickup_bench = []
	enemy_bench = []

func calculate_experience_threshold():
	experience_threshold_bonus = experience_threshold_base * 2 * level
	
func get_current_upgrade_value(upgrade_type : UPGRADES) -> float:
	if upgrade_type == UPGRADES.ATTACK_SPEED:
		return attack_speed
	elif upgrade_type == UPGRADES.ATTACK_DAMAGE:
		@warning_ignore("narrowing_conversion")
		return attack_damage
	elif upgrade_type == UPGRADES.HEALTH:
		return max_health
	elif upgrade_type == UPGRADES.MOVESPEED:
		return movespeed
	elif upgrade_type == UPGRADES.SWORD_LEVEL:
		return sword_level_base
	elif upgrade_type == UPGRADES.BOW_LEVEL:
		return bow_level_base
	elif upgrade_type == UPGRADES.STAFF_LEVEL:
		return staff_level_base
	else:
		return 0

func get_new_upgrade_value(upgrade_type : UPGRADES) -> float:
	var base = get_current_upgrade_value(upgrade_type)
	if upgrade_type == UPGRADES.ATTACK_SPEED:
		if base < 0.11:
			return 0
		else:
			return base - 0.05
	elif upgrade_type == UPGRADES.ATTACK_DAMAGE:
		return base + 1
	elif upgrade_type == UPGRADES.HEALTH:
		return base + 5
	elif upgrade_type == UPGRADES.MOVESPEED:
		if base > 199:
			return 0
		else:
			return base + 10
	elif upgrade_type == UPGRADES.SWORD_LEVEL:
		return sword_level_base + 1
	elif upgrade_type == UPGRADES.BOW_LEVEL:
		return bow_level_base + 1
	elif upgrade_type == UPGRADES.STAFF_LEVEL:
		return staff_level_base + 1
	else:
		return 0
		
func get_current_resource() -> int:
	match chosen_class:
		0:
			return 0
		1:
			return 0
		2: 
			return mana
		3:
			return 0
		4:
			return faith_base
	return 0
	
func spend_current_resource(cost : float):
	match chosen_class:
		0:
			return
		1:
			return
		2: 
			mana -= cost
		3:
			return
		4:
			faith -= cost
