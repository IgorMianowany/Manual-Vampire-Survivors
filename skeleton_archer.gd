class_name SkeletonArcher
extends Enemy

signal attack_signal

var projectile_speed : float = 100

func _ready() -> void:
	super()
	collision_calc_cooldown = 10
	repulsion_force = 100
	attack_signal.connect(attack)
	$CollisionShape2D.shape.size = Vector2(15, 20)

func _physics_process(delta: float) -> void:
	if not active:
		return
	frame_counter -= 1
	if frame_counter == 0:
		calculate_position()
		frame_counter = 15
	#global_position += velocity * delta
	super(delta)
	
func _process(delta: float) -> void:
	if velocity == Vector2.ZERO and not is_attacking:
		attack()

func calculate_position():
	distance_to_player = global_position.distance_to(player.global_position)
	player_direction = global_position.direction_to(player.global_position) * speed
	if distance_to_player > 150 + variation * 100:
		velocity = player_direction
	elif distance_to_player < 60 + variation * 100:
		velocity = player_direction * -1
	else:
		velocity = Vector2.ZERO
	

func attack():
	if not is_attacking:
		is_attacking = true
		var attack_projectile = PlayerState.enemy_projectile_bench.pop_front()
		#add_child(attack_projectile)
		if attack_projectile == null:
			return
		attack_projectile.active = true
		attack_projectile.global_position = global_position + direction * 15
		attack_projectile.direction = global_position.direction_to(player.global_position)
		attack_projectile.damage = 10
		attack_projectile.velocity = projectile_speed * attack_projectile.direction
		attack_projectile._reusable_ready()
		await(get_tree().create_timer(1.25 + variation * 10).timeout)
		is_attacking = false
