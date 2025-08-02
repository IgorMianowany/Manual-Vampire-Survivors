class_name Player
extends CharacterBody2D

@export var base_speed : float = 125
@export var invincibility_time : float = 1
@export var attack_time : float = .5
@export var attack_range : float = 15
@export var attack_damage : float = 3.5
@export var attack_cooldown : float = 1
@export var knockback_power : float = 1
@export var self_knockback_speed : float = 5
@export var player_class : int = 1
@export var bullet_manager : BulletManager
var invincibility_timer : float = 0
var is_invincible : bool = false
var invincibility_animation_frequency = 5
var invincibility_animation_counter = 0
var is_attacking : bool = false
var is_knocked_back : bool = false
var knockback_time : float = 0.4
var enemies_inside_hitbox : Array[Slime]
var max_time = 9999999
var hammers : Array[PalladinHammerSkill]
var bubble_ready : bool = false
var bubble_hits : int = 0
var base_view_distance : float = 3
var previous_pos : Vector2
var current_pos : Vector2 = Vector2.ZERO
var is_dashing : bool = false
var dash_duration : float = .1
var can_dash : bool = true
var puke_texture : CompressedTexture2D = preload("res://assets/sprites/objects/puke.png")
var lightning_strike_scene = preload("res://lightning_strike.tscn")
var lightning_strike_timer : Timer = Timer.new()
var knife_summon_scene = preload("res://knife_summon.tscn")
var current_interactable : Interactable = null
var min_interact_distance : float = 100
var current_interact_distance : float = 100
var holy_bolt_scene := preload("res://holy_bolt.tscn")
var holy_explosion_scene := preload("res://holy_explosion.tscn")
var holy_beam_scene := preload("res://holy_beam.tscn")

enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var direction : DirectionEnum = DirectionEnum.DOWN

func _ready() -> void:
	$GameTimer.wait_time = max_time
	#check this bitch
	$AttackRangePointer/PlayerHitbox.damage = attack_damage
	$AttackRangePointer/PlayerHitbox.is_player_hitbox = true
	PlayerState.after_class_chosen.connect(set_class)
	PlayerState.add_palladin_hammer.connect(add_palladin_hammer)
	PlayerState.add_bubble_shield.connect(add_bubble_shield)
	PlayerState.add_lightning_strike.connect(add_lightning_strike)
	$DashTimer.timeout.connect(reset_can_dash)
	PlayerState.puke.connect(handle_puke)
	add_child(lightning_strike_timer)
	lightning_strike_timer.timeout.connect(lightning_strike)
	lightning_strike_timer.autostart = true
	PlayerState.add_knife.connect(handle_knife_spawn)
	PlayerState.health = PlayerState.max_health

func _physics_process(delta: float) -> void:
	PlayerState.player_position = global_position
	previous_pos = current_pos
	current_pos = global_position
	#var zoom_bonus = Vector2(base_view_distance + PlayerState.view_distance_bonus, base_view_distance  + PlayerState.view_distance_bonus)
	#$Camera2D.zoom = zoom_bonus.clamp(Vector2(1,1), Vector2(5,5))
	
	$UI/CanvasLayer/HealthForDebug.text = str(PlayerState.max_health)
	if PlayerState.health <= 0:
		return
	if is_invincible:
		invincibility_timer += delta
		invincibility_animation_counter += 1
		if invincibility_animation_counter > invincibility_animation_frequency:
			$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible
			invincibility_animation_counter = 0
		
	if invincibility_timer > invincibility_time:
		$PlayerHurtbox.global_position = global_position
		$PlayerHurtbox/HurtboxCollision.set_deferred("disabled", false)
		is_invincible = false
		$AnimatedSprite2D.visible = true
		invincibility_timer = 0
		
	if Input.is_action_pressed("attack") and PlayerState.active_enemies_count <= 1000:
		for i in range(0, 10):
			var light_enemy := preload("res://light_necromancer.tscn").instantiate()
			light_enemy.player = self
			get_parent().add_child(light_enemy)
			PlayerState.active_enemies_count += 1
			light_enemy.set_enemy_position(get_global_mouse_position())
			#
			#
			#
			#var light_slime_enemy := preload("res://light_slime.tscn").instantiate()
			#light_slime_enemy.player = self
			#get_parent().add_child(light_slime_enemy)
			#PlayerState.active_enemies_count += 1
			#light_slime_enemy.set_enemy_position(get_global_mouse_position())
	#if Input.is_action_just_pressed("attack"):
		#var light_enemy := preload("res://light_necromancer.tscn").instantiate()
		#light_enemy.player = self
		#get_parent().add_child(light_enemy)
		#PlayerState.active_enemies_count += 1
		#light_enemy.set_enemy_position(get_global_mouse_position())

		#attack()
		set_attack_direction()
		$Weapon.attack(global_position, (get_global_mouse_position() - global_position).normalized()) 
	
	#if Input.is_action_just_pressed("attack"):
		#bullet_manager.spawn_bullet(global_position.direction_to(get_global_mouse_position()), 500, global_position)
		
	if Input.is_action_just_pressed("level_up"):
		PlayerState.add_exp(PlayerState.experience_threshold)
		
	if Input.is_action_just_pressed("pause"):
		Engine.max_fps = 30 if Engine.max_fps == 60 else 60
		
	if Input.is_action_just_pressed("death"):
		take_damage(99999999, Vector2.ZERO, 0, false, false)
	
	if Input.is_action_just_pressed("dash") and PlayerState.has_dash and can_dash:
		$DashHitbox/CollisionShape2D.disabled = false
		$DashHitbox.monitorable = true
		$DashHitbox.damage = PlayerState.dash_damage
		$PlayerHurtbox.collision_mask = 0
		is_dashing = true
		can_dash = false
		$DashEffect.scale.x = -1 if direction == DirectionEnum.LEFT else 1
		$DashEffect.emitting = true

		$DashEffect.texture = $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation,0)
		var dash_direction = previous_pos.direction_to(current_pos)
		if dash_direction == Vector2.ZERO:
			match direction:
				0:
					dash_direction = Vector2.UP
				1:
					dash_direction = Vector2.DOWN
				2:
					dash_direction = Vector2.LEFT
				3:
					dash_direction = Vector2.RIGHT
					
		velocity = dash_direction * (base_speed + PlayerState.movespeed_bonus) * 8
		await(get_tree().create_timer(dash_duration).timeout)
		is_dashing = false
		$DashTimer.start(PlayerState.dash_cooldown)
		PlayerState.dash_timer.wait_time = PlayerState.dash_cooldown
		PlayerState.dash_timer.start()
		$DashEffect.emitting = false
		$DashHitbox.monitorable = false
		$DashHitbox/CollisionShape2D.disabled = true
		
		await(get_tree().create_timer(.5).timeout)
		$PlayerHurtbox.collision_mask = 16
		

	if Input.is_action_just_pressed("zoom_in"):
		$Camera2D.zoom += Vector2(.1,.1)
	if Input.is_action_just_pressed("zoom_out"):
		$Camera2D.zoom -= Vector2(.1,.1)
	$BubbleShield.visible = bubble_ready
	$Marker2D/ChainLightningReady.visible = PlayerState.chain_lightning_ready
	
	if Input.is_action_just_pressed("interact"):
		if current_interactable == null:
			return
		current_interactable.interact()
		$UI.toggle_interact_visibility(false)
		(current_interactable as Interactable).toggle_interact_outline(false)
	
	if $InteractRange.get_overlapping_areas().size() > 0:
		current_interact_distance = global_position.distance_to(current_interactable.global_position)
		for area in $InteractRange.get_overlapping_areas():
			if global_position.distance_to(area.global_position) < current_interact_distance:
				current_interactable.toggle_interact_outline(false)
				current_interactable = area
				current_interactable.toggle_interact_outline(true)
				
	if Input.is_action_just_pressed("spell_1") and PlayerState.chosen_class == 4:
		if PlayerState.holy_bolt_cooldown_base <= 0  and PlayerState.get_current_resource() > $Skills/Skill1.cost:
			PlayerState.holy_bolt_cooldown_base = 1
			$Skills/Skill1.cast_skill()
			PlayerState.spend_current_resource($Skills/Skill1.cost)
			#var holy_bolt = holy_bolt_scene.instantiate()
			#add_child(holy_bolt)
			#holy_bolt.speed = 100
			#holy_bolt.damage = 1
			#holy_bolt.direction = global_position.direction_to(get_global_mouse_position())
			#holy_bolt.global_position = global_position
			#holy_bolt.set_skill_stats()
	if Input.is_action_just_pressed("spell_2") and PlayerState.chosen_class == 4:
		if PlayerState.holy_explosion_cooldown_base <= 0 and PlayerState.get_current_resource() > $Skills/Skill2.cost:
			PlayerState.holy_explosion_cooldown_base = 1
			$Skills/Skill2.cast_skill()
			PlayerState.spend_current_resource($Skills/Skill2.cost)
			#var holy_explosion = holy_explosion_scene.instantiate()
			#add_child(holy_explosion)
			#holy_explosion.damage = 5
			#holy_explosion.global_position = get_global_mouse_position()
			#holy_explosion.set_skill_stats()
	if Input.is_action_just_pressed("spell_3") and PlayerState.chosen_class == 4:
		if PlayerState.holy_beam_cooldown_base <= 0  and PlayerState.get_current_resource() > $Skills/Skill3.cost:
			PlayerState.holy_beam_cooldown_base = 1
			$Skills/Skill3.cast_skill()
			PlayerState.spend_current_resource($Skills/Skill3.cost)

			#var holy_beam = holy_beam_scene.instantiate()
			#add_child(holy_beam)
			#holy_beam.direction = global_position.direction_to(get_global_mouse_position())
			#holy_beam.damage = 5
			#holy_beam.global_position = global_position
			#holy_beam.set_skill_stats()
		

	if not is_knocked_back and not is_dashing:
		handle_movement()
	handle_animation()
	handle_weapon_rotation()
	move_and_collide(velocity * delta)
	
func _process(delta: float) -> void:
	PlayerState.holy_bolt_cooldown_base -= delta
	PlayerState.holy_explosion_cooldown_base -= delta
	PlayerState.holy_beam_cooldown_base -= delta
	
func handle_animation() -> void:
	if $Weapon.is_attacking and PlayerState.chosen_class == 0:
		if direction == DirectionEnum.UP:
			$AnimatedSprite2D.play("attack_up")
		elif direction == DirectionEnum.DOWN:
			$AnimatedSprite2D.play("attack_down")
		elif direction == DirectionEnum.RIGHT:
			$AnimatedSprite2D.play("attack_right")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("attack_right")
			$AnimatedSprite2D.flip_h = true
	elif velocity != Vector2.ZERO:
		if direction == DirectionEnum.UP:
			$AnimatedSprite2D.play("move_up")
		elif direction == DirectionEnum.DOWN:
			$AnimatedSprite2D.play("move_down")
		elif direction == DirectionEnum.RIGHT:
			$AnimatedSprite2D.play("move_right")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("move_right")
			$AnimatedSprite2D.flip_h = true
	else:
		if direction == DirectionEnum.UP:
			$AnimatedSprite2D.play("idle_back")
		elif direction == DirectionEnum.DOWN:
			$AnimatedSprite2D.play("idle_front")
		elif direction == DirectionEnum.RIGHT:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = true
			
func handle_movement() -> void:
	var direction_left := Input.get_axis("move_left", "move_right")
	var direction_down := Input.get_axis("move_down", "move_up")
	var final_speed = base_speed + PlayerState.movespeed_bonus
	if direction_left:
		velocity.x = direction_left * final_speed
		if not $Weapon.is_attacking:
			if direction_left == 1:
				direction = DirectionEnum.RIGHT
			else:
				direction = DirectionEnum.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, base_speed)
		
	if direction_down:
		velocity.y = direction_down * final_speed
		if not $Weapon.is_attacking:
			if direction_down == 1:
				direction = DirectionEnum.DOWN
			else:
				direction = DirectionEnum.UP
	else:
		velocity.y = move_toward(velocity.y, 0, base_speed)
			
func take_damage(damage : float, knockback_direction : Vector2, incoming_knockback_power : float, _is_poisoning : bool, _is_crit : bool) -> void:
	if not is_invincible:
		if bubble_ready:
			bubble_hits += 1
			if bubble_hits > PlayerState.bubble_shield_max_hits:
				$BubbleShield.play("pop")
				await(get_tree().create_timer(.6).timeout)
				bubble_ready = false
				bubble_hits = 0
				await(get_tree().create_timer(PlayerState.bubble_shield_cooldown).timeout)
				bubble_ready = true
				$BubbleShield.play("idle")
		else:
			#$PlayerHurtbox.global_position = Vector2(10, 10)
			$PlayerHurtbox/HurtboxCollision.set_deferred("disabled", true)
			PlayerState.health -= damage
			is_invincible = true
			is_knocked_back = true
			$UtilTimer.start(knockback_time)
			velocity = knockback_direction * self_knockback_speed * incoming_knockback_power
			await($UtilTimer.timeout)
			is_knocked_back = false
			if PlayerState.health <= 0:
				$AnimatedSprite2D.play("death")
				PlayerState.final_score = get_elapsed_time()
				PlayerState.player_death.emit()
	
# this is an old attack function
func attack() -> void:
	if not $Weapon.is_attacking:
		set_attack_direction()
		is_attacking = true
		
		$UtilTimer.start(.15)
		await($UtilTimer.timeout)
		$AttackRangePointer/PlayerHitbox/CollisionShape2D.disabled = false
		$UtilTimer.start(attack_time)
		

		$AttackShapeCast.target_position = $AttackRangePointer.position
		for index in $AttackShapeCast.get_collision_count():
			var enemy = $AttackShapeCast.get_collider(index)
			enemy.take_damage(attack_damage, position.direction_to(enemy.position), knockback_power)
		
		
		
		await($UtilTimer.timeout)
		is_attacking = false
		$AttackRangePointer/PlayerHitbox/CollisionShape2D.disabled = true	

func set_attack_direction() -> void:
	var mouse_direction = global_position.direction_to(get_global_mouse_position())
	if mouse_direction.x > .75:
		direction = DirectionEnum.RIGHT
	elif mouse_direction.x < -.75:
		direction = DirectionEnum.LEFT
	elif mouse_direction.y > 0:
		direction = DirectionEnum.DOWN
	else:
		direction = DirectionEnum.UP
	rotate_attack_range()
	
	
func rotate_attack_range() -> void:
	if direction == DirectionEnum.RIGHT:
		$AttackRangePointer.position = Vector2(attack_range, 0)
		$AttackRangePointer.rotation_degrees = 90
	elif direction == DirectionEnum.LEFT:
		$AttackRangePointer.position = Vector2(-attack_range, 0)
		$AttackRangePointer.rotation_degrees = -90
	elif direction == DirectionEnum.DOWN:
		$AttackRangePointer.rotation_degrees = 180
		$AttackRangePointer.position = Vector2(0, attack_range)
	else:
		$AttackRangePointer.position = Vector2(0, -attack_range)
		$AttackRangePointer.rotation_degrees = 0

func get_elapsed_time() -> int:
	return int(max_time - $GameTimer.time_left + 1)
	
func set_class():
	$AnimatedSprite2D/HolyCross.visible = false
	match PlayerState.chosen_class:
		0:
			$Weapon.weapon_type = $Weapon/Sword
			PlayerState.class_level = PlayerState.sword_level_base
		1:
			$Weapon.weapon_type = $Weapon/Bow
			$Marker2D/WeaponSprite.texture = $Weapon/Bow.weapon_texture
			$Marker2D/WeaponSprite.scale = Vector2(0.05,0.05)
			PlayerState.class_level = PlayerState.bow_level_base
		2:
			$Weapon.weapon_type = $Weapon/Staff
			$Marker2D/WeaponSprite.texture = $Weapon/Staff.weapon_texture
			$Marker2D/WeaponSprite.scale = Vector2(0.15,0.15)
			PlayerState.max_mana = 10 * PlayerState.staff_level_base
			PlayerState.class_level = PlayerState.staff_level_base
		3:
			$Weapon.weapon_type = $Weapon/Shuriken
			$Marker2D/WeaponSprite.texture = $Weapon/Shuriken.weapon_texture
			$Marker2D/WeaponSprite.scale = Vector2(0.02,0.02)
			PlayerState.class_level = PlayerState.staff_level_base
		4:
			$Weapon.weapon_type = $Weapon/PrayerBook
			$Skills/Skill1.skill_scene = holy_bolt_scene
			$Skills/Skill2.skill_scene = holy_explosion_scene
			$Skills/Skill3.skill_scene = holy_beam_scene
			$UI.set_skills(holy_bolt_scene.instantiate(), holy_explosion_scene.instantiate(), holy_beam_scene.instantiate())

			$AnimatedSprite2D/HolyCross.visible = true
			PlayerState.class_level = PlayerState.prayer_book_level_base
		

func handle_weapon_rotation():
	#Get the mouse position relative to the screen
	var mouse_pos = get_global_mouse_position()

	# Calculate the direction from the sprite to the mouse
	var weapon_direction = (mouse_pos - global_position).normalized()
	# Calculate the rotation angle based on the direction
	var angle = weapon_direction.angle()
	# Set the sprite's rotation to the calculated angle
	#$Marker2D/WeaponSprite.rotation = angle
	$Marker2D.rotation = angle
	
func add_palladin_hammer():
	var hammer_scene = preload("res://palladin_hammer_skill.tscn")
	var hammer_instance = hammer_scene.instantiate()
	add_child(hammer_instance)
	hammer_instance.global_position = global_position
	hammers.append(hammer_instance)
	var i = 0
	for hammer in hammers: 
		@warning_ignore("integer_division")
		hammer.rotation_degrees = (360 / hammers.size()) * i
		hammer.add_speed(PlayerState.palladin_hammer_speed)
		hammer.set_damage(PlayerState.palladin_hammer_damage)
		i += 1
		
func add_bubble_shield():
	bubble_ready = true
	
func reset_can_dash():
	can_dash = true
	
func handle_puke():
	var sprite = Sprite2D.new()
	sprite.texture = puke_texture
	sprite.global_position = global_position
	sprite.z_index = 0
	sprite.scale = Vector2(0.1,0.1)
	sprite.set_as_top_level(true)
	add_child(sprite)
	
	sprite.reparent(get_parent())

func lightning_strike():
	$LightningStrikeRange/CollisionShape2D.disabled = false
	$LightningStrikeRange.monitoring = true
	$LightningStrikeRange/CollisionShape2D.shape.radius = PlayerState.lightning_strike_range
	var enemies = $LightningStrikeRange.get_overlapping_bodies()
	var lightning_strike_position : Vector2
	
	if enemies.size() > 0:
		for enem in enemies:
			if enem != null and enem.health > 0:
				lightning_strike_position = enem.global_position
				break
		var lightning_strike_instance = lightning_strike_scene.instantiate()
		lightning_strike_instance.global_position = lightning_strike_position
		add_child(lightning_strike_instance)
	$LightningStrikeRange/CollisionShape2D.disabled = true
		
func add_lightning_strike():
	lightning_strike()
	lightning_strike_timer.wait_time = PlayerState.lightning_strike_cooldown
	lightning_strike_timer.start()
	
func handle_knife_spawn():
	var knife_instance = knife_summon_scene.instantiate()
	add_child(knife_instance)
	knife_instance.global_position = global_position + Vector2(15,0)
	knife_instance.player = self

func _on_interact_range_area_entered(area: Area2D) -> void:
	if current_interactable != null:
		return
	current_interactable = area
	current_interact_distance = global_position.distance_to(area.global_position)
	(area as Interactable).toggle_interact_outline(true)
	$UI.toggle_interact_visibility(true)
	

func _on_interact_range_area_exited(area: Area2D) -> void:
	(area as Interactable).toggle_interact_outline(false)
	if current_interactable == area:
		(current_interactable as Interactable).toggle_interact_outline(false)
		current_interactable = null
		$UI.toggle_interact_visibility(false)
		var other_interactables = $InteractRange.get_overlapping_areas()
		if other_interactables.size() > 0:
			current_interactable = other_interactables[0]
			(current_interactable as Interactable).toggle_interact_outline(true)
			$UI.toggle_interact_visibility(true)
			
	
