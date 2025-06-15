class_name HolyBolt
extends CommonSkill

var damage : float = 1
var speed : float
var velocity : Vector2
var direction : Vector2
var lifetime : float = 3
var player : Player


func _ready() -> void:
	set_as_top_level(true)
	icon = preload("res://assets/sprites/Holy Knight/HolyAssets/Holy VFX 01/Separated Frames/Holy VFX 01 Repeatable1.png")
	

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	global_position += velocity * delta

func set_skill_stats():
	speed = 100
	damage = 1
	global_position = player_position
	direction = global_position.direction_to(get_global_mouse_position())
	velocity = direction * speed
	$Hitbox.damage = damage
	#get_angle_to(direction)
	look_at(global_position + direction)




func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("loop_projectile")
