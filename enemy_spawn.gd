extends Node2D
@export var cooldown : float = 5
@export var min_cooldown : float = .25
@export var player : Player 
@export var limit : int = 12
var upperLimit : int = 420

var dice_roll


var regex : RegEx

var slime := preload("res://light_slime.tscn") 
var skeleton_archer := preload("res://light_skeleton_archer.tscn")
var necromancer := preload("res://light_necromancer.tscn")
var count : int = 0

func _ready() -> void:
	$Timer.autostart = true
	$Timer.wait_time = cooldown
	$Timer.start()

func _on_timer_timeout() -> void:
	min_cooldown = 0.25
	@warning_ignore("narrowing_conversion")
	if count < limit and PlayerState.slime_count < clampi(PlayerState.game_time, upperLimit, upperLimit):
		dice_roll = randf_range(0,10)
		## spawn 10 at the time
		#for i in range(1, 10):
			#var slime_instance
			#if name.contains("26"):
				#slime_instance = skeleton_archer.instantiate()
			#else:
				#slime_instance = slime.instantiate()
			#count += 1
			#PlayerState.slime_spawned += 1
			#slime_instance.test_name = name.right(name.length() - 10) + ":" + str(PlayerState.slime_spawned)
			#slime_instance.active = true
			#slime_instance.player = player
			#slime_instance.global_position = global_position
			#add_child(slime_instance)
			#PlayerState.active_enemies_count += 1
		var enemy_instance : LightEnemy
		if dice_roll <= 5:
			enemy_instance = slime.instantiate()
		elif dice_roll <= 8:
			enemy_instance = skeleton_archer.instantiate()
		else:
			enemy_instance = necromancer.instantiate()
		enemy_instance.active = true
		enemy_instance.player = player
		add_child(enemy_instance)
		enemy_instance.set_enemy_position(global_position)
		count += 1
		PlayerState.slime_spawned += 1
		PlayerState.active_enemies_count += 1
		#slime_instance2.test_name = name.right(name.length() - 10) + ":" + str(PlayerState.slime_spawned)
		#slime_instance2.active = true
		#slime_instance2.player = player
		#slime_instance2.global_position = global_position
		#add_child(slime_instance2)
		#count += 1
		#PlayerState.slime_spawned += 1
		@warning_ignore("integer_division")
		cooldown = clampf(cooldown - player.get_elapsed_time() / 100, min_cooldown, cooldown)
		$Timer.wait_time = cooldown + randf_range(0, 1)
	elif count < limit and PlayerState.active_enemies_count < upperLimit:
		if PlayerState.enemy_bench.size() > 0:
			var pooled_slime = PlayerState.enemy_bench.pop_front()
			pooled_slime.spawn_enemy(global_position)
			pooled_slime.active = true
			count += 1
			PlayerState.active_enemies_count += 1
