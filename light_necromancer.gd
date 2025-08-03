class_name LightNecromancer
extends LightEnemy

# BEFORE DYING PLAY DIE ANIMATION ON ALL CHILD NODES

var slime_scene := preload("res://light_slime.tscn")
var attack_check_time : float = 1 
var child_holder
signal summon_signal

func _ready() -> void:
	child_holder = $Position/ChildrenHolder
	collision_shape.radius = 16
	super()
	animated_sprite_2d = $Position/NecromancerSprite2D
	$Position/SummoningCircle.scale = Vector2(.25, .25)
	$Position/SummoningCircle.set_as_top_level(true)
	summon_signal.connect(_on_summon_signal)

func _physics_process(delta: float) -> void:
	if hp < 0:
		return
	frame_counter -= 1
	if frame_counter == 0:
		#calculate_position()
		frame_counter = 15
	attack_check_time -= delta
	super(delta)
	
func _process(delta: float) -> void:
	if hp < 0:
		return
	if attack_check_time < 0:
		attack_check_time = 1
		if get_pos().distance_to(player.global_position) < 250:
			speed = 0
		else:
			speed = 1000
	if speed == 0 and not is_attacking:
		summon()
		
	handle_animation(variation)
	$Position/SummoningCircle.rotate(delta)
	super(delta)
	
func summon():
	if not is_attacking and PlayerState.active_enemies_count < 800 and not PlayerState.necro_spawn_bench.is_empty():
		is_attacking = true

		var slime = PlayerState.necro_spawn_bench.pop_front()
		if slime == null:
			return
		slime.process_mode = PROCESS_MODE_ALWAYS
		slime.player = player
		if slime.get_parent() != null:
			slime.reparent($Position/ChildrenHolder)
		else:
			$Position/ChildrenHolder.add_child(slime)
		#$Position/ChildrenHolder.reparent(slime)
		#var summon_position = get_pos() + 200 * get_pos().direction_to(player.global_position)
		var summon_position = get_pos() + 200 * get_pos().direction_to(player.global_position)
		await(get_tree().create_timer(variation * 2).timeout)
		$Position/SummoningCircle.global_position = summon_position
		$Position/SummoningCircle.visible = true
		await(get_tree().create_timer(1).timeout)


		slime.set_enemy_position(summon_position)

		PlayerState.slime_spawned += 1
		PlayerState.active_enemies_count += 1
		await(get_tree().create_timer(1).timeout)
		$Position/SummoningCircle.visible = false
		await(get_tree().create_timer(3).timeout)
		is_attacking = false

func calculate_position():
	distance_to_player = global_position.distance_to(player.global_position)
	player_direction = global_position.direction_to(player.global_position) * speed
	if distance_to_player > 150 + variation * 100:
		velocity = player_direction
	elif distance_to_player < 60 + variation * 100:
		velocity = player_direction * -1
	else:
		velocity = Vector2.ZERO
	
func handle_animation(_anim_variation : float):
	if hp < 0:
		return
	elif velocity == Vector2.ZERO and not animated_sprite_2d.animation == "summon":
		animated_sprite_2d.play("idle_down")
	elif not animated_sprite_2d.animation == "summon":
		animated_sprite_2d.play("run")
		
func spawn_enemy(_spawn_position: Vector2):
	animated_sprite_2d.play("idle_down")

func _on_necromancer_sprite_2d_animation_finished() -> void:
	super._on_animation_finished(animated_sprite_2d.animation)
	
func take_damage(incoming_damage : float, _attack_direction : Vector2, _knockback_power : float, _is_poison : bool = false, is_crit : bool = false):
	if hp - incoming_damage <= 0:
		for child in $Position/ChildrenHolder.get_children():
			child.hp = -1
			child.take_damage(0, _attack_direction, _knockback_power)
			
	super(incoming_damage, _attack_direction, _knockback_power, _is_poison, is_crit)

func _on_summon_signal():
	animated_sprite_2d.play("summon")
	
