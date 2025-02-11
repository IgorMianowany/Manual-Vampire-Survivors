extends CharacterBody2D

var target : Slime 
var direction : Vector2
var speed : float = 100
var player : Player 
var direction_variation : Vector2
var distance : float
@onready var timer : Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 1
	timer.autostart = true
	player = owner
	set_as_top_level(true)
	global_position = player.global_position + Vector2(15,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if target != null:
		speed = clamp(global_position.distance_squared_to(target.global_position), 50, 200)
	velocity = speed * direction * direction_variation
	move_and_slide()


func _on_timer_timeout() -> void:
	target = null
	var enemies = $TargetRange.get_overlapping_bodies()
	print(enemies.size())
	for enemy in enemies:
		target = enemy
		break
	if target == null or global_position.distance_to(player.global_position) > 200:
		direction_variation = Vector2(randf_range(0.75, 1.25), randf_range(0.75, 1.25)	)
		direction = global_position.direction_to(player.global_position)
	else:
		direction_variation = Vector2.ONE
		direction = global_position.direction_to(target.global_position)
	look_at(position + direction)
