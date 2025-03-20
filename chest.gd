class_name Chest
extends Interactable
	
func interact():
	if interacted:
		return
	interacted = true
	open()

func open():
	for animation_frame in $Sprite2D.hframes:
		$Sprite2D.frame = animation_frame
		await(get_tree().create_timer(.2).timeout)
		if animation_frame == 2:
			for index in range(0,10):
				var experience_pickup = PlayerState.experience_pickup_bench.pop_front()
				experience_pickup.reset(global_position + Vector2(randf_range(-5, 5),randf_range(-10,10)))

	
