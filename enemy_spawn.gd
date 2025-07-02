extends Node2D
@export var cooldown : float = 5
@export var min_cooldown : float = .25
@export var player : Player 
@export var limit : int = 12
var upperLimit : int = 420


var regex : RegEx

var slime := preload("res://slime.tscn") 
var skeleton_archer := preload("res://skeleton_archer.tscn")
var necromancer := preload("res://necromancer.tscn")
var count : int = 0

func _ready() -> void:
	$Timer.autostart = true
	$Timer.wait_time = cooldown
	$Timer.start()

func _on_timer_timeout() -> void:
	min_cooldown = 0.25
	@warning_ignore("narrowing_conversion")
	if count < limit and PlayerState.slime_count < clampi(PlayerState.game_time, upperLimit, upperLimit):
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
		var slime_instance = slime.instantiate()
		if name.contains("26"):
			slime_instance = skeleton_archer.instantiate()
		#elif name.contains("99"):
			#slime_instance = necromancer.instantiate()

		slime_instance.test_name = name.right(name.length() - 10) + ":" + str(PlayerState.slime_spawned)
		slime_instance.active = true
		slime_instance.player = player
		slime_instance.global_position = global_position
		add_child(slime_instance)
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
