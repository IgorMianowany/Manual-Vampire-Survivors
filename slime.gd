class_name Slime
extends Enemy

var closest_slime : Enemy
var push_away_cooldown : float = 0
var push_var : float = randf_range(-1, 1)


func _on_push_away_body_entered(body: Node2D) -> void:
	if body is Slime and closest_slime == null:
		closest_slime = body
		


func _on_push_away_body_exited(body: Node2D) -> void:
	if body == closest_slime:
		closest_slime = null


func _ready() -> void:
	sprite = $AnimatedSprite2D
	super()
	#set_as_top_level(true)
	#PlayerState.slime_count += 1
	##var current_parent = get_parent()
	##while(true):
		##if current_parent.name == "LayerHolder":
			##reparent(current_parent)
			##break
		##current_parent = current_parent.get_parent()
	##@warning_ignore("integer_division")
	##max_health += player.get_elapsed_time() / 10
	#player = get_parent().player
	#health = max_health
	#$PoisonTimer.timeout.connect(take_poison_damage)
	#variation = randf_range(0, jump_variation)
	#healthbar_new.init_health(max_health)
#
func _physics_process(delta: float) -> void:
	if closest_slime != null:
		velocity += closest_slime.global_position.direction_to(global_position) * 4
	if push_away_cooldown < 0:
		push_away_cooldown = 1
		closest_slime = null
	jump_timer += delta
	push_away_cooldown -= delta
	jump_toward_player(variation)
	super(delta)
	


func _on_vision_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("boid"):
		boids_i_see.append(area.owner)


func _on_vision_area_exited(area: Area2D) -> void:
	if area:
		boids_i_see.erase(area.owner)
		
func jump_toward_player(_jump_variation : float) -> void:
	if not jump_timer > jump_cooldown + variation or is_jumping or  is_pulled:
		return
	var new_direction := Vector2.ZERO
	if jump_timer < jump_cooldown + jump_duration + _jump_variation and health > 0:
		is_jumping = true
		repulsion_force = .1
		$SlimeHitbox/CollisionShape2D.disabled = false
		player_position = player.global_position + Vector2(randf_range(-direction_variation, direction_variation), randf_range(-direction_variation, direction_variation))

		if not is_knocked_back:
			# this is a weird way to check if slime reached it's jump destination before finishing the jump
			# in this case it will go back and forth trying to reach exactly this point, instead of keeping the momentum
			# this fixes that case
			new_direction = position.direction_to(player_position)
			$AnimatedSprite2D.play("move_down")
			if player_direction + new_direction < Vector2(0.001, 0.001) and player_direction + new_direction > Vector2(-0.001, -0.001):
				return
			velocity = position.direction_to(player_position) * speed
		else:
			is_jumping = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		jump_timer = 0
		$SlimeHitbox/CollisionShape2D.disabled = true
		repulsion_force = 0
		velocity = Vector2.ZERO
	player_direction = new_direction

#
#func jump_toward_player(_jump_variation : float) -> void:
	#var new_direction := Vector2.ZERO
	#if jump_timer < jump_cooldown + jump_duration + _jump_variation and health > 0:
		#is_jumping = true
		#$SlimeHitbox/CollisionShape2D.disabled = false
		#player_position = player.global_position + Vector2(randf_range(-direction_variation, direction_variation), randf_range(-direction_variation, direction_variation))
#
		#if not is_knocked_back:
			## this is a weird way to check if slime reached it's jump destination before finishing the jump
			## in this case it will go back and forth trying to reach exactly this point, instead of keeping the momentum
			## this fixes that case
			#new_direction = position.direction_to(player_position)
			#$AnimatedSprite2D.play("move_down")
			#if player_direction + new_direction < Vector2(0.001, 0.001) and player_direction + new_direction > Vector2(-0.001, -0.001):
				#return
			#velocity = position.direction_to(player_position) * speed
		#else:
			#is_jumping = false
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.y = move_toward(velocity.y, 0, speed)
		#jump_timer = 0
		#$SlimeHitbox/CollisionShape2D.disabled = true
	#player_direction = new_direction
#
#func handle_animation(animation_variation : float) -> void:
	#direction = position.direction_to(player.position)
	#if health <= 0:
		#$AnimatedSprite2D.play("die")
	#elif velocity != Vector2.ZERO and not is_knocked_back:
		#if direction.x > 0  and jump_timer < jump_cooldown + jump_duration + animation_variation:
			#if direction.x > direction.y:
				#$AnimatedSprite2D.play("move_right")
				#$AnimatedSprite2D.flip_h = false
				#facing_direction = DirectionEnum.RIGHT
			#else:
				#$AnimatedSprite2D.play("move_down")
				#$AnimatedSprite2D.flip_h = false
				#facing_direction = DirectionEnum.DOWN
		#elif jump_timer < jump_cooldown + jump_duration + animation_variation:
			#if direction.x < direction.y:
				#$AnimatedSprite2D.play("move_right")
				#$AnimatedSprite2D.flip_h = true
				#facing_direction = DirectionEnum.LEFT
			#else:
				#$AnimatedSprite2D.play("move_up")
				#$AnimatedSprite2D.flip_h = false
				#facing_direction = DirectionEnum.UP
	#elif not is_knocked_back:
		#if facing_direction == DirectionEnum.RIGHT:
			#$AnimatedSprite2D.play("idle_right")
			#$AnimatedSprite2D.flip_h = false
		#elif facing_direction == DirectionEnum.DOWN:
			#$AnimatedSprite2D.play("idle_down")
			#$AnimatedSprite2D.flip_h = false
		#elif facing_direction == DirectionEnum.LEFT:
			#$AnimatedSprite2D.play("idle_right")
			#$AnimatedSprite2D.flip_h = true
		#else:
			#$AnimatedSprite2D.play("idle_up")
			#$AnimatedSprite2D.flip_h = false
			#
#
#
#func _on_hitbox_body_entered(body: Node2D) -> void:
	#if body is Player and is_jumping and health > 0:
		#body.take_damage(damage, position.direction_to(player_position), knockback_power)
#
#func take_damage(incoming_damage : float, knockback_direction : Vector2, knockback : float, is_poisoning : bool = false, is_crit : bool = false) -> void:	
	#if is_poisoning:
		#start_poison(PlayerState.poison_damage, PlayerState.poison_duration)
	#
	#if health > 0:
		#var tween : Tween = create_tween()
		#tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.1).from(15)
		#health -= incoming_damage
		#healthbar_new.health = health
		#$HitParticles.emitting = true
		#DamageNumbers.display_number(int(incoming_damage), damage_numbers_origin.global_position, is_crit)
		#$HitParticles.set_direction(knockback_direction)
		#
		#if PlayerState.chain_lightning_ready:
			#if PlayerState.enemies_hit_by_chain_lightning.size() == 0:
				#PlayerState.start_chain_lightning_timer()
			#handle_chain_lightning_logic()
	#if health > 0:
		#is_knocked_back = true
		#velocity = knockback_direction * (knockback * .8) * speed
		#$AnimatedSprite2D.play("take_damage")
		#if jump_timer > 0.8 and not is_poisoning:
			#jump_timer -= 0.8
		#await(get_tree().create_timer(.8).timeout)
		#is_knocked_back = false
	#if health <= 0:
		 ##this is done so all the colliders are not in a way after entity death, as 
		 ##set_deferred can be wonky when working with a lot of entites of the same type
		#for property in get_children():
			#if property is Timer:
				#continue
			#if property is AnimatedSprite2D:
				#continue	
			#if property is Control:
				#continue
			#property.global_position = Vector2.ZERO
		#active = false
		##$ProjectileDestroyArea.set_deferred("monitorable", false)
		#$AnimatedSprite2D.play("die")
		#await(get_tree().create_timer(1).timeout)
#
	#$HitParticles.emitting = false
#
#func _on_collision_area_body_entered(body: Node2D) -> void:
	#if is_knocked_back and body.name != "Player":
		#velocity = Vector2.ZERO
		#take_damage(1, body.global_position.direction_to(global_position), 0)
		#
#func start_poison(new_damage : float, duration : float):
	#is_poisoned = true
	#$AnimatedSprite2D.modulate = "d800da"
	##if there is new poison effect we overwrite the damage,
	##otherwise we just extend the existing 
	##maybe change to > instead of != ?
	#if poison_damage != new_damage:
		#poison_damage = new_damage
		#$PoisonTimer.start(1)
	#poison_ticks_left = duration
	#
#func take_poison_damage():
	#if poison_ticks_left > 0:
		#take_damage(poison_damage, Vector2.ZERO, 0, false)
		#poison_ticks_left -= 1
	#else:
		#is_poisoned = false
		#$AnimatedSprite2D.modulate = "ffffff"
		#$PoisonTimer.stop()
		#
#func handle_chain_lightning_logic():
	#$ChainLightningAnimation.set_process(true)
	#$ChainLightningShapeCast.enabled = true
	#$ChainLightningAnimation.process_mode = Node.PROCESS_MODE_PAUSABLE
	#
	#await(get_tree().create_timer(.1).timeout)
	#
	#
	#$ChainLightningShapeCast.shape.radius = PlayerState.chain_lightning_range
	## to niżej musi być poza ifem jakoś
	#PlayerState.start_chain_lightning_timer()
	#if not PlayerState.enemies_hit_by_chain_lightning.has(self):
		#if PlayerState.enemies_hit_by_chain_lightning.size() == 0:
			#PlayerState.first_enemy_hit_name = name
		#PlayerState.enemies_hit_by_chain_lightning.append(self)
	#else:
		#pass
	#for index in $ChainLightningShapeCast.get_collision_count():
		#if index >= $ChainLightningShapeCast.get_collision_count():
			#continue
		#var enemy = $ChainLightningShapeCast.get_collider(index)
		#if enemy != null and not PlayerState.enemies_hit_by_chain_lightning.has(enemy):
			#if PlayerState.enemies_hit_by_chain_lightning.size() <= PlayerState.chain_lightning_max_hits and PlayerState.chain_lightning_ready:
				#$ChainLightningAnimation.animate_chain_lightning(global_position, enemy.global_position)
				#await(get_tree().create_timer(.1).timeout)
				#if is_instance_valid(enemy):
					#enemy.take_damage(PlayerState.chain_lightning_damage, Vector2.ZERO, 0, false, false)
				#pass
			#else:
				#PlayerState.chain_lightning_current_hits = 0
				#PlayerState.clear_enemies_chain_lightning()
		## kiedy nie ma wystarczasjąco przeciwników tez ma działać
		#pass
	#if PlayerState.first_enemy_hit_name == name:
		#PlayerState.clear_enemies_chain_lightning()
	#$ChainLightningAnimation.set_process(false)
	#$ChainLightningShapeCast.set_deferred("enabled", false)
	#
#
#func _on_animated_sprite_2d_animation_finished() -> void:
	#if $AnimatedSprite2D.animation == "die":
		#if PlayerState.experience_pickup_bench.size() != 0:
			#var experience_pickup_new = PlayerState.experience_pickup_bench.pop_front()
			#experience_pickup_new.reset(global_position)
		#$Control.global_position = global_position
		##experience_pickup_new.turn_on_collision()
		##experience_pickup_new.global_position = global_position
		##experience_pickup_new.player = null
		##experience_pickup_new.active = true
		##experience_pickup_new.speed = 10000
		##PlayerState.active_enemies_count -= 2
		#PlayerState.coins_base += money
		#reset_enemy()
	#is_jumping = false
	#$AnimatedSprite2D.play("idle_down")
#
#func reset_enemy():
	#PlayerState.active_enemies_count -= 1
	#speed = 0
	#global_position = Vector2(-1000,1000)
	#for property in get_children():
		#if property is Timer:
			#continue
		#property.global_position = global_position
	#PlayerState.enemy_bench.append(self)
	#
#func spawn_enemy(spawn_position : Vector2):
	#active = true
	#PlayerState.active_enemies_count += 1
	#speed = 75
	#healthbar_new.init_health(max_health)
	#$Control/Label.text = test_name
#
	#
	#@warning_ignore("integer_division")
	#max_health += player.get_elapsed_time() / 10
	#health = max_health
	#global_position = spawn_position
	#for property in get_children():
		#if property is Timer:
			#continue
		#property.global_position = global_position
		
