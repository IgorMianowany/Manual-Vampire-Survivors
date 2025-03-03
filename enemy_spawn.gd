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
	if count < limit and PlayerState.slime_count < clampi(100 + PlayerState.game_time, 50, 80):
		var slime_instance = slime.instantiate()
		slime_instance.player = player
		slime_instance.global_position = global_position
		add_child(slime_instance)
		count += 1
		@warning_ignore("integer_division")
		cooldown = clampf(cooldown - player.get_elapsed_time() / 100, min_cooldown, cooldown)
		$Timer.wait_time = cooldown + randf_range(0, 1)
