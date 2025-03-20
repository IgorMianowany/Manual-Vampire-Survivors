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
