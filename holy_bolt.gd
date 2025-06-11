class_name HolyBolt
extends Node2D

var cost : float
var damage : float = 1
var speed : float
var velocity : Vector2
var direction : Vector2
var lifetime : float = 3


func _ready() -> void:
	set_as_top_level(true)

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	global_position += velocity * delta

func set_skill_stats():
	velocity = direction * speed
	$Hitbox.damage = damage
	#get_angle_to(direction)
	look_at(global_position + direction)




func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("loop_projectile")
