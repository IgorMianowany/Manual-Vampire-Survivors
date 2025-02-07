class_name StatSheet
extends Control

var stat_line_scene := preload("res://stat_line.tscn")

func _ready() -> void:
	refresh_stat_sheet()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("check_stats"):
		toggle_stat_sheet()

func toggle_stat_sheet():
	get_tree().paused = not $CanvasLayer.visible
	$CanvasLayer.visible = not $CanvasLayer.visible
	refresh_stat_sheet()
	
func refresh_stat_sheet():
	clear_previous_stats()
	var stats_to_display = PlayerState.get_first_vbox_stats()
	var stats_left = stats_to_display.duplicate()
	var counter = 0
	for stat in stats_to_display:
		var stat_line = stat_line_scene.instantiate()
		stat_line.set_label(stat)
		$CanvasLayer/ColorRect/VBoxContainer1.add_child(stat_line)
		stats_left.erase(stat)
		counter += 1
		if counter > 7:
			break
	counter = 0
	stats_to_display = stats_left.duplicate()
	for stat in stats_to_display:
		var stat_line = stat_line_scene.instantiate()
		stat_line.set_label(stat)
		$CanvasLayer/ColorRect/VBoxContainer2.add_child(stat_line)
		stats_left.erase(stat)
		counter += 1
		if counter > 10:
			break
	counter = 0
	stats_to_display = stats_left.duplicate()
	for stat in stats_to_display:
		var stat_line = stat_line_scene.instantiate()
		stat_line.set_label(stat)
		$CanvasLayer/ColorRect/VBoxContainer3.add_child(stat_line)
		stats_left.erase(stat)
		counter += 1
		if counter > 10:
			break
	counter = 0
	stats_to_display = stats_left.duplicate()
	for stat in stats_to_display:
		var stat_line = stat_line_scene.instantiate()
		stat_line.set_label(stat)
		$CanvasLayer/ColorRect/VBoxContainer4.add_child(stat_line)
		stats_left.erase(stat)
		counter += 1
		if counter > 10:
			break
	counter = 0
	stats_to_display = stats_left.duplicate()
	for stat in stats_to_display:
		var stat_line = stat_line_scene.instantiate()
		stat_line.set_label(stat)
		$CanvasLayer/ColorRect/VBoxContainer5.add_child(stat_line)
		stats_left.erase(stat)
		counter += 1
		if counter > 10:
			break
	counter = 0
	stats_to_display = stats_left.duplicate()

func clear_previous_stats():
	for node in $CanvasLayer/ColorRect.get_children():
		for child_node in node.get_children():
			node.remove_child(child_node)
			child_node.queue_free()
