class_name ExperiencePickup
extends CharacterBody2D

var player : Player
var speed = 10000
var active : bool = false
@export var experience_points = 1

func _ready() -> void:
	visible = true
	collision_mask = 8
	
func _physics_process(delta: float) -> void:
	if not active:
		return
	if is_instance_valid(player):
		velocity = (speed - global_position.distance_to(player.global_position)*10) * global_position.direction_to(player.global_position) * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body

func _on_collision_range_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerState.add_exp(experience_points)
		global_position = get_parent().global_position
		player = null
		active = false
		speed = 0
		velocity = Vector2.ZERO
		PlayerState.experience_pickup_bench.append(self)
