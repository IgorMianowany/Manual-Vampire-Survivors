class_name Necromancer
extends Enemy

var slime_scene := preload("res://slime.tscn")

func _ready() -> void:
	super()
	$EnemyHurtbox/CollisionShape2D.shape.radius = 20
	$SummoningCircle.scale = Vector2(.25, .25)
	$SummoningCircle.set_as_top_level(true)

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
	if not active:
		return
	if velocity == Vector2.ZERO and not is_attacking:
		summon()
	handle_animation(variation)
	$SummoningCircle.rotate(delta)
	
func summon():
	if not is_attacking:
		var summon_position = global_position + Vector2(50, 50)
		is_attacking = true
		$AnimatedSprite2D2.play("summon")
		$SummoningCircle.global_position = summon_position
		$SummoningCircle.visible = true
		await(get_tree().create_timer(1).timeout)
		var slime = slime_scene.instantiate()
		slime.test_name = name.right(name.length() - 10) + ":" + str(PlayerState.slime_spawned)
		slime.active = true
		slime.player = player
		slime.global_position = summon_position
		add_child(slime)
		PlayerState.slime_spawned += 1
		PlayerState.active_enemies_count += 1
		#summoning_circle.global_position = summon_position
		await(get_tree().create_timer(1).timeout)
		$SummoningCircle.visible = false
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
	
func handle_animation(variation : float):
	if is_dead:
		return
	elif velocity == Vector2.ZERO and not $AnimatedSprite2D2.animation == "summon":
		$AnimatedSprite2D2.play("idle")
	elif not $AnimatedSprite2D2.animation == "summon":
		$AnimatedSprite2D2.play("run")

func take_damage(incoming_damage : float, knockback_direction : Vector2, knockback : float, is_poisoning : bool = false, is_crit : bool = false):
	if health - incoming_damage <= 0:
		$AnimatedSprite2D2.play("die")
		is_dead = true
		await($AnimatedSprite2D2.animation_finished)
		$AnimatedSprite2D2.visible = false
	super(incoming_damage, knockback_direction, knockback, is_poisoning, is_crit)

func _on_animated_sprite_2d_2_animation_finished() -> void:
	$AnimatedSprite2D2.pause()
	super._on_animation_finished($AnimatedSprite2D2.animation)

func spawn_enemy(spawn_position: Vector2):
	$AnimatedSprite2D2.play("idle")
	super(spawn_position)
