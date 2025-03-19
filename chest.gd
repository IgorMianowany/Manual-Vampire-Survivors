class_name Chest
extends Sprite2D

func _ready() -> void:
	open()

func open():
	for animation_frame in hframes:
		frame = animation_frame
		await(get_tree().create_timer(.2).timeout)
