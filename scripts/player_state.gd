extends Node

var max_health : float = 100
var experience : int = 0
var experience_threshold : int = 10
var level : int = 0
@onready var health : float = max_health

var debug_value : int = 0

signal death
signal level_up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_exp(exp : int) -> void:
	experience += exp
	if experience >= experience_threshold:
		level += 1
		experience = experience % experience_threshold
		experience_threshold += 5
