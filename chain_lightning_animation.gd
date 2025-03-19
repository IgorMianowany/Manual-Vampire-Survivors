class_name ChainLightningAnimation
extends Node2D


func animate_chain_lightning(start_pos : Vector2, end_pos : Vector2):
	$Lightning.visible = true
	$Lightning.global_position = start_pos
	$Lightning.look_at(end_pos)
	scale_to_fit_points(start_pos, end_pos)
	$Lightning/AnimatedSprite2D.play("animate")
	await(get_tree().create_timer(.5).timeout)
	$Lightning.visible = false

func scale_to_fit_points(point_a : Vector2, point_b : Vector2):
	# Get the distance between the two points
	var distance = point_a.distance_to(point_b)
	
	# Calculate the width of the sprite based on the distance
	var sprite_width = $Lightning/TestLightning.texture.get_width()
	
	# Calculate the scaling factor to fit the sprite between the two points
	var scale_factor = distance / sprite_width
	scale_factor = clampf(scale_factor, scale_factor, .75)
	
	# Scale the sprite
	$Lightning.scale = Vector2(scale_factor, scale_factor)
	
	# Position the sprite so that its left edge is at point_a
	$Lightning.global_position = point_a
