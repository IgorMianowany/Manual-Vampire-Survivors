extends Control

@onready var upgrade_container = $CanvasLayer/HBoxContainer

func _ready() -> void:
	get_tree().paused = true
	for node in upgrade_container.get_children():
		node.upgrade_selected.connect(_quit)
		
func _input(event):
	var mouse_position = get_local_mouse_position()
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		for node in upgrade_container.get_children():
			print(node.get_global_rect())
			print(mouse_position)
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _quit():
	get_tree().paused = false
	queue_free()
