class_name ExperiencePickup
extends CharacterBody2D

var player : Player
var speed = 10000
var active : bool = false
@export var experience_points = 1

func _ready() -> void:
	visible = true
	collision_mask = 8
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$CollisionRange/CollisionRangeShape.set_deferred("disabled", true)
	
func _physics_process(delta: float) -> void:
	if not active:
		return
	if is_instance_valid(player):
		velocity = (speed - global_position.distance_to(player.global_position)*10) * global_position.direction_to(player.global_position) * delta
	move_and_slide()

func turn_on_collision():
	#$Area2D/CollisionShape2D.disabled = false
	#$CollisionRange/CollisionRangeShape.disabled = false
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	$CollisionRange/CollisionRangeShape.set_deferred("disabled", false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		$Area2D/CollisionShape2D.set_deferred("disabled", true)

func _on_collision_range_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerState.add_exp(experience_points)
		global_position = get_parent().global_position
		player = null
		active = false
		speed = 0
		velocity = Vector2.ZERO
		$CollisionRange/CollisionRangeShape.set_deferred("disabled", true)
		PlayerState.experience_pickup_bench.append(self)
		
func reset(_global_position : Vector2):
	global_position = _global_position
	await(get_tree().create_timer(.5).timeout)
	turn_on_collision()
	player = null
	active = true
	speed = 10000
		
