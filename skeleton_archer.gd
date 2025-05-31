class_name SkeletonArcher
extends Enemy

var distance_to_player : float
var is_attacking : bool = false
var projectile := preload("res://arrow.tscn")

func jump_toward_player(_jump_variation : float) -> void:
	var new_direction := Vector2.ZERO
	velocity = position.direction_to(player_position) * speed

func _physics_process(delta: float) -> void:
	$Control/Label.text = test_name
	if not active:
		return
	#print(global_position.distance_to(player.global_position) < 50)
	distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > 115:
		velocity = global_position.direction_to(player.global_position) * speed
	elif distance_to_player < 85:
		velocity = global_position.direction_to(player.global_position) * speed * -1
	else:
		velocity = Vector2.ZERO
		attack()
	if is_pulled:
		if pull_source != null:
			direction = global_position.direction_to(pull_source.global_position)
			var new_speed = clampf(speed * 1000 * (1 / global_position.distance_squared_to(pull_source.global_position)), 0, 75)
			velocity = direction * new_speed
	move_and_slide()
	
func attack():
	if not is_attacking:
		is_attacking = true
		var attack_projectile = projectile.instantiate()
		add_child(attack_projectile)
		attack_projectile.change_target(true)
		attack_projectile.active = true
		attack_projectile.global_position = global_position + direction * 15
		attack_projectile.direction = global_position.direction_to(player.global_position)
		attack_projectile.damage = 10
		attack_projectile.pierce = -1
		attack_projectile.crit_chance = 0
		attack_projectile.crit_multi = 0
		attack_projectile._reusable_ready()
		await(get_tree().create_timer(1).timeout)
		is_attacking = false
