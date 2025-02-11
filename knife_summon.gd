extends CharacterBody2D

var target : Slime 
var direction : Vector2
var speed : float = 100
@export var player : Player 
@onready var timer : Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("dupa")
	timer.wait_time = 1
	timer.one_shot = false
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if target != null:
		if global_position.distance_to(target.global_position) > 10:
			velocity += speed * direction
		else:
			timer.start()


func _on_timer_timeout() -> void:
	print("dupa")
	target = $TargetRange.get_overlapping_bodies()[0]
	if global_position.distance_to(player.global_position) > 100:
		direction = global_position.direction_to(player.global_position)
	elif target != null:
		direction = global_position.direction_to(target.global_position)
	print("dupa2")
	
