extends Node2D
@export var cooldown : float = 5
@export var min_cooldown : float = 1
@export var player : Player 
@export var limit : int = 12

var slime := preload("res://slime.tscn") 
var count : int = 0

func _ready() -> void:
	$Timer.autostart = true
	$Timer.wait_time = cooldown
	$Timer.start()

func _on_timer_timeout() -> void:
	@warning_ignore("narrowing_conversion")
	if count < limit and PlayerState.slime_count < clampi(PlayerState.game_time, 300, 300) and false:
		var slime_instance = slime.instantiate()
		slime_instance.player = player
		slime_instance.global_position = global_position
		add_child(slime_instance)
		count += 1
		PlayerState.active_enemies_count += 1
		PlayerState.slime_spawned += 1
		@warning_ignore("integer_division")
		cooldown = clampf(cooldown - player.get_elapsed_time() / 100, min_cooldown, cooldown)
		$Timer.wait_time = cooldown + randf_range(0, 1)
	elif count < limit and PlayerState.active_enemies_count < 300:
		if PlayerState.enemy_bench.size() > 0:
			var pooled_slime = PlayerState.enemy_bench.pop_front()
			pooled_slime.spawn_enemy(global_position)
			count += 1
