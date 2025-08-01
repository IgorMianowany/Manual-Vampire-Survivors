class_name LightSlime
extends LightEnemy

func _ready() -> void:
	animated_sprite_2d = $Position/AnimatedSprite2D
	super()
	
	
	
func _manual_spawn_ready():
	animated_sprite_2d = $Position/AnimatedSprite2D
	
