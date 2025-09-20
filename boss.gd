class_name Boss
extends CharacterBody2D

var move_cooldown = 3
var move_timer = 3
var move_duration = 1.5
var player : Player
var speed = 0
var player_direction : Vector2
var is_attacking : bool = false
var spawn_position : Vector2
var attack_duration : float = 10
var action_cooldown : bool = false
var chance = 0
signal move
signal attack

func _ready() -> void:
	move.connect(handle_move)
	attack.connect(handle_attack)

func _process(delta: float) -> void:
	move_timer -= delta
	if move_timer < 0 and not is_attacking and not action_cooldown:
		player_direction = global_position.direction_to(player.global_position)
		move_timer = move_cooldown
		if randf() > 1 - chance:
			move.emit()
		else:
			#move.emit()
			attack.emit()
			chance = 1
		
func _physics_process(delta: float) -> void:
	velocity = player_direction * speed * delta
	move_and_slide()
	
func handle_move():
	if is_attacking:
		return
	speed = 10000
	await(get_tree().create_timer(move_duration).timeout)
	speed = 0
	
func handle_attack():
	is_attacking = true
	spiral_projectile_attack()
	await(get_tree().create_timer(attack_duration).timeout)
	is_attacking = false
	action_cooldown = true
	await(get_tree().create_timer(2).timeout)
	action_cooldown = false
	
func spiral_projectile_attack():
	var start_dir = Vector2.UP
	while(is_attacking):
		var projectile := preload("res://boss_projectile.tscn").instantiate()
		projectile.global_position = global_position
		projectile.start_pos = global_position
		projectile.direction = start_dir
		projectile.player = player
		add_child(projectile)
		#var projectile2 := preload("res://boss_projectile.tscn").instantiate()
		#projectile2.global_position = global_position
		#projectile2.direction = start_dir * -1
		#add_child(projectile2)
		#start_dir = start_dir.rotated(.25)
		await(get_tree().create_timer(0.25).timeout)
		break
		##for i in range(1,15):

		#var projectile2 := preload("res://boss_projectile.tscn").instantiate()
		#projectile2.global_position = global_position
		#projectile2.direction = start_dir * -1
		#add_child(projectile2)
		#await(get_tree().create_timer(0.25).timeout)
		#start_dir = start_dir.rotated(deg_to_rad(10))
