class_name Player
extends CharacterBody2D

@export var speed : float = 150
enum directionEnum {UP, DOWN, LEFT, RIGHT}
var direction : directionEnum = directionEnum.DOWN

func _physics_process(delta: float) -> void:
	var direction_left := Input.get_axis("move_left", "move_right")
	var direction_down := Input.get_axis("move_down", "move_up")
	
	if direction_left:
		velocity.x = direction_left * speed
		if direction_left == 1:
			direction = directionEnum.RIGHT
		else:
			direction = directionEnum.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction_down:
		velocity.y = direction_down * speed
		if direction_down == 1:
			direction = directionEnum.DOWN
		else:
			direction = directionEnum.UP
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	handle_animation()
	move_and_slide()
	
func handle_animation() -> void:
	if velocity != Vector2.ZERO:
		if direction == directionEnum.UP:
			$AnimatedSprite2D.play("move_up")
		elif direction == directionEnum.DOWN:
			$AnimatedSprite2D.play("move_down")
		elif direction == directionEnum.RIGHT:
			$AnimatedSprite2D.play("move_right")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("move_right")
			$AnimatedSprite2D.flip_h = true
	else:
		if direction == directionEnum.UP:
			$AnimatedSprite2D.play("idle_back")
		elif direction == directionEnum.DOWN:
			$AnimatedSprite2D.play("idle_front")
		elif direction == directionEnum.RIGHT:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = true
