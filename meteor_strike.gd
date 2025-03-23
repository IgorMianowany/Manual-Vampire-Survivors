extends Area2D

var speed : float = 100
var land_position_y : float = 0
var land_position_x : float = 0
var start_position_x : float
var travel_distance : float = 150
var exploded

func _ready() -> void:
	set_as_top_level(true)
	land_position_y = global_position.y
	land_position_x = global_position.x
	$AnimatedSprite2D.global_position.y = $AnimatedSprite2D.global_position.y - travel_distance
	$AnimatedSprite2D.global_position.x = $AnimatedSprite2D.global_position.x + randf_range(-100,100)
	start_position_x = $AnimatedSprite2D.global_position.x

func _process(delta: float) -> void:
	print(land_position_x - global_position.x)
	if $AnimatedSprite2D.position.y >= -90:
		$Hitbox.monitorable = true
		$AnimatedSprite2D.global_position = global_position
		$AnimatedSprite2D.play("explosion")
		#for i in $Sprite2D.hframes:
			#for j in $Sprite2D.vframes:
				#$Sprite2D.frame_coords = Vector2(i,j)
				#await(get_tree().create_timer(.2).timeout)
	else: 
		$AnimatedSprite2D.global_position.y += 100 * delta
		if abs($AnimatedSprite2D.position.x) > 5:
			$AnimatedSprite2D.global_position.x += 1

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "explosion":
		queue_free()
