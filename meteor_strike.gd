extends Area2D

var speed : float = 100
var land_position_y : float = 0
var exploded

func _ready() -> void:
	land_position_y = global_position.y
	$AnimatedSprite2D.global_position.y = $AnimatedSprite2D.global_position.y - 100

func _process(delta: float) -> void:
	if $AnimatedSprite2D.position.y >= -120:
		$AnimatedSprite2D.global_position = global_position
		$AnimatedSprite2D.play("explosion")
	else: 
		$AnimatedSprite2D.global_position.y = $AnimatedSprite2D.global_position.y + 100 * delta

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "explosion":
		queue_free()
