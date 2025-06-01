class_name SkeletonArcher
extends Enemy

var distance_to_player : float
var is_attacking : bool = false
var projectile := preload("res://arrow.tscn")

func _ready() -> void:
	super()
	collision_calc_cooldown = 10
	repulsion_force = 100

func _physics_process(delta: float) -> void:
	if not active:
		return
	distance_to_player = global_position.distance_to(player.global_position)
	player_direction = global_position.direction_to(player.global_position) * speed
	if distance_to_player > 150 + variation * 100:
		velocity = player_direction
	elif distance_to_player < 60 + variation * 100:
		velocity = player_direction * -1
	else:
		velocity = Vector2.ZERO
		attack()

	super(delta)


	
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
		attack_projectile._reusable_ready()
		await(get_tree().create_timer(2).timeout)
		is_attacking = false
