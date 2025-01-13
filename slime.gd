extends CharacterBody2D

@export var player : Player
@export var speed : float = 100
@export var jump_cooldown : float = 2
@export var jump_duration : float = 1
var jump_timer : float = 0
var direction : Vector2 = Vector2.ZERO
var player_position : Vector2

@onready var start_pos : Vector2 = position

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if jump_timer > jump_cooldown - .2 and jump_timer < jump_cooldown:
		player_position = player.position
		
	jump_timer += delta
	
	if jump_timer > jump_cooldown:
		jump_toward_player()
	
	handle_animation()
	move_and_slide()

func jump_toward_player() -> void:
	if jump_timer < jump_cooldown + jump_duration:
		velocity = position.direction_to(player_position) * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
		jump_timer = 0

func handle_animation() -> void:
	direction = position.direction_to(player.position)
	
	if velocity != Vector2.ZERO:
		if direction.x > 0:
			if direction.x > direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.play("move_down")
				$AnimatedSprite2D.flip_h = false
		else:
			if direction.x < direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.play("move_up")
				$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle_down")
		#if direction == directionEnum.UP:
			#$AnimatedSprite2D.play("move_up")
		#elif direction == directionEnum.DOWN:
			#$AnimatedSprite2D.play("move_down")
		#elif direction == directionEnum.RIGHT:
			#$AnimatedSprite2D.play("move_right")
			#$AnimatedSprite2D.flip_h = false
		#else:
			#$AnimatedSprite2D.play("move_right")
			#$AnimatedSprite2D.flip_h = true
	#else:
		#if direction == directionEnum.UP:
			#$AnimatedSprite2D.play("idle_back")
		#elif direction == directionEnum.DOWN:
			#$AnimatedSprite2D.play("idle_front")
		#elif direction == directionEnum.RIGHT:
			#$AnimatedSprite2D.play("idle_right")
			#$AnimatedSprite2D.flip_h = false
		#else:
			#$AnimatedSprite2D.play("idle_right")
			#$AnimatedSprite2D.flip_h = true
