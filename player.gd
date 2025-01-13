class_name Player
extends CharacterBody2D

@export var speed : float = 125
@export var invincibility_time : float = 1
var invincibility_timer : float = 0
var is_invincible : bool = false
var invincibility_animation_frequency = 5
var invincibility_animation_counter = 0

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
		
	var direction_left := Input.get_axis("move_left", "move_right")
	var direction_down := Input.get_axis("move_down", "move_up")
	
	if direction_left:
		velocity.x = direction_left * speed
		if direction_left == 1:
			direction = DirectionEnum.RIGHT
		else:
			direction = DirectionEnum.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_down:
		velocity.y = direction_down * speed
		if direction_down == 1:
			direction = DirectionEnum.DOWN
		else:
			direction = DirectionEnum.UP
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	handle_animation()
	move_and_slide()
	
func handle_animation() -> void:
	if velocity != Vector2.ZERO:
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
			
func take_damage(damage : float, knockback_direction : Vector2, knockback_power : float) -> void:
	if not is_invincible:
		PlayerState.health -= damage
		is_invincible = true
		print(knockback_direction)
		velocity = knockback_direction * speed * knockback_power
		if PlayerState.health <= 0:
			death.emit()
