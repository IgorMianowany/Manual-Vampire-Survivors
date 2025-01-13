extends CharacterBody2D

@export var player : Player
@export var speed : float = 100
@export var jump_cooldown : float = 2
@export var jump_duration : float = 1
@export var damage : float = 10
var jump_timer : float = 0
var direction : Vector2 = Vector2.ZERO
var player_position : Vector2
var is_jumping : bool = false
enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var facing_direction : DirectionEnum

@onready var start_pos : Vector2 = position

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_jumping:
		player_position = player.position
		
	jump_timer += delta
	
	handle_animation()
	
	if jump_timer > jump_cooldown:
		jump_toward_player()
	
	move_and_slide()

func jump_toward_player() -> void:
	if jump_timer < jump_cooldown + jump_duration:
		is_jumping = true
		velocity = position.direction_to(player_position) * speed
	else:
		is_jumping = false
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		jump_timer = 0

func handle_animation() -> void:
	direction = position.direction_to(player.position)
	if velocity != Vector2.ZERO:
		if direction.x > 0  and jump_timer < jump_cooldown + 0.1:
			if direction.x > direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.RIGHT
			else:
				$AnimatedSprite2D.play("move_down")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.DOWN
		elif jump_timer < jump_cooldown + 0.1:
			if direction.x < direction.y:
				$AnimatedSprite2D.play("move_right")
				$AnimatedSprite2D.flip_h = true
				facing_direction = DirectionEnum.LEFT
			else:
				$AnimatedSprite2D.play("move_up")
				$AnimatedSprite2D.flip_h = false
				facing_direction = DirectionEnum.UP
	else:
		if facing_direction == DirectionEnum.RIGHT:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = false
		elif facing_direction == DirectionEnum.DOWN:
				$AnimatedSprite2D.play("idle_down")
				$AnimatedSprite2D.flip_h = false
		elif facing_direction == DirectionEnum.LEFT:
			$AnimatedSprite2D.play("idle_right")
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.play("idle_up")
			$AnimatedSprite2D.flip_h = false
			


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
