extends Node2D
@export var cooldown : float = 5
var slime := preload("res://slime.tscn")
@export var player : Player 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.autostart = true
	$Timer.wait_time = cooldown
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	print("dupa")
	var slime_instance = slime.instantiate()
	slime_instance.player = player
	add_child(slime_instance)
