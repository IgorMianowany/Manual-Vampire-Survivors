extends Node2D

@export var hit_damage : float = 5
@export var rotation_speed : float = 0.08
@export var rotation_distance : float = 50
var starting_rotation : float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D/HammerHitbox.damage = hit_damage
	$Sprite2D.position.y = -rotation_distance
	rotation = starting_rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(rotation_speed)
	if int(rotation_degrees) > 360 + starting_rotation:
		rotation_degrees = 0 + starting_rotation
	
