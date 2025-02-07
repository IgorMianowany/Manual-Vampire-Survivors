class_name PalladinHammerSkill
extends Node2D

@export var rotation_speed : float = 200
@export var rotation_distance : float = 50
var starting_rotation : float = 0
# Called when the node enters the scene tree for the first time
func _ready() -> void:
	$Sprite2D.position.y = -rotation_distance
	rotation = starting_rotation

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#rotate(rotation_speed)
	#if int(rotation_degrees) > 360 + starting_rotation:
		#rotation_degrees = 0 + starting_rotation

func _physics_process(delta: float) -> void:
	rotate(rotation_speed)
	if int(rotation_degrees) > 360 + starting_rotation:
		rotation_degrees = 0 + starting_rotation
		
func set_damage(damage : float):
	$Sprite2D/HammerHitbox.damage = damage

func add_speed(speed : float):
	rotation_speed = speed + 0.02
	
