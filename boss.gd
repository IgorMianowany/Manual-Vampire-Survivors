class_name Boss
extends CharacterBody2D

var move_cooldown = 3
var move_timer = 3
var move_duration = 1.5
var player : Player
var speed = 0
var player_dierction : Vector2
var is_attacking : bool = false
var spawn_position : Vector2
signal move
signal attack

func _ready() -> void:
	move.connect(handle_move)
	attack.connect(handle_attack)

func _process(delta: float) -> void:
	move_timer -= delta
	if move_timer < 0:
		move_timer = move_cooldown
		if randf() > 1:
			move.emit()
		else:
			move.emit()
			
			attack.emit()
		
func _physics_process(delta: float) -> void:
	velocity = player_dierction * speed * delta
	move_and_slide()
	
func handle_move():
	if is_attacking:
		return
	player_dierction = global_position.direction_to(player.global_position)
	speed = 10000
	await(get_tree().create_timer(move_duration).timeout)
	speed = 0
	
func handle_attack():
	print("attacking")
	spiral_projectile_attack()
	
func spiral_projectile_attack():
	var projectile := preload("res://boss_projectile.tscn").instantiate()
	projectile.global_position = global_position
	projectile.direction = player_dierction
	add_child(projectile)
	
