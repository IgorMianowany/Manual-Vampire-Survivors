extends Control

@onready var upgrade_container = $CanvasLayer/HBoxContainer

func _ready() -> void:
	PlayerState.level_up.connect(_upgrade_selection_visible)
	get_tree().paused = true
	for node in upgrade_container.get_children():
		node.upgrade_selected.connect(_quit)
		
func _input(event):
	# this function is not really working right now because of mouse position shenenigans i'm not
	# yet equiped to deal with at this time, upgrades selected with button
	var mouse_position = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		for node in upgrade_container.get_children():
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _quit():
	get_tree().paused = false
	queue_free()

func _upgrade_selection_visible():
	add_child($CanvasLayer)
