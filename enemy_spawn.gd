extends Node2D
@export var cooldown : float = 5
@export var player : Player 
@export var limit : int = 9999

var slime := preload("res://slime.tscn") 
var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.autostart = true
	$Timer.wait_time = cooldown
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Timer.wait_time = $Timer.wait_time + randf_range(0, 1)

func _on_timer_timeout() -> void:
	if count < limit:
		var slime_instance = slime.instantiate()
		slime_instance.player = player
		slime_instance.global_position = global_position
		add_child(slime_instance)
		count += 1
