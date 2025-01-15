class_name Player
extends CharacterBody2D

@export var speed : float = 125
@export var invincibility_time : float = 1
@export var attack_time : float = .5
@export var attack_range : float = 15
@export var attack_damage : float = 3.5
@export var knockback_power : float = 1
@export var self_knockback_speed : float = 5
var invincibility_timer : float = 0
var is_invincible : bool = false
var invincibility_animation_frequency = 5
var invincibility_animation_counter = 0
var is_attacking : bool = false
var is_knocked_back : bool = false
var knockback_time : float = 0.4


signal death

enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var direction : DirectionEnum = DirectionEnum.DOWN

func _physics_process(delta: float) -> void:
	if is_invincible:
		invincibility_timer += delta
		invincibility_animation_counter += 1
		if invincibility_animation_counter > invincibility_animation_frequency:
			$AnimatedSprite2D.visible = not $AnimatedSprite2D.visible
			invincibility_animation_counter = 0
		
	if invincibility_timer > invincibility_time:
		is_invincible = false
		$AnimatedSprite2D.visible = true
		invincibility_timer = 0
		
	if Input.is_action_pressed("attack"):
		attack()
	
	
	
	if not is_knocked_back:
		handle_movement()
	handle_animation()
	move_and_slide()
	
func handle_animation() -> void:
	if is_attacking:
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
	if direction_left:
		velocity.x = direction_left * speed
		if not is_attacking:
			if direction_left == 1:
				direction = DirectionEnum.RIGHT
			else:
				direction = DirectionEnum.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_down:
		velocity.y = direction_down * speed
		if not is_attacking:
			if direction_down == 1:
				direction = DirectionEnum.DOWN
			else:
				direction = DirectionEnum.UP
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
			
func take_damage(damage : float, knockback_direction : Vector2, knockback_power : float) -> void:
	if not is_invincible:
		PlayerState.health -= damage
		is_invincible = true
		is_knocked_back = true
		$UtilTimer.start(knockback_time)
		velocity = knockback_direction * self_knockback_speed * knockback_power
		await($UtilTimer.timeout)
		is_knocked_back = false
		if PlayerState.health <= 0:
			death.emit()

func attack() -> void:
	if not is_attacking:
		set_attack_direction()
		is_attacking = true
		
		$UtilTimer.start(.15)
		await($UtilTimer.timeout)
		$AttackRangePointer/Hitbox/CollisionShape2D.disabled = false
		$UtilTimer.start(attack_time)
		

		$AttackShapeCast.target_position = $AttackRangePointer.position
		for index in $AttackShapeCast.get_collision_count():
			var enemy = $AttackShapeCast.get_collider(index)
			enemy.take_damage(attack_damage, position.direction_to(enemy.position), knockback_power)
		
		
		
		await($UtilTimer.timeout)
		is_attacking = false
		$AttackRangePointer/Hitbox/CollisionShape2D.disabled = true
	
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
	
