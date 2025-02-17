extends CharacterBody2D

var player : Player
var speed = 10000
@export var experience_points = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	collision_mask = 8
	#set_as_top_level(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(player):
		velocity = (speed - global_position.distance_to(player.global_position)*10) * global_position.direction_to(player.global_position) * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		


func _on_collision_range_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerState.add_exp(experience_points)
		queue_free()
