extends Node2D
@export var cooldown : float = 5
@export var player : Player 

var slime := preload("res://slime.tscn") 
var count : int = 0
var limit : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.autostart = true
	$Timer.wait_time = cooldown
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if count < limit:
		var slime_instance = slime.instantiate()
		slime_instance.player = player
		slime_instance.global_position = global_position
		add_child(slime_instance)
		count += 1
