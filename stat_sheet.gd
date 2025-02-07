class_name StatSheet
extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("check_stats"):
		toggle_stat_sheet()

func toggle_stat_sheet():
	get_tree().paused = not $CanvasLayer.visible
	$CanvasLayer.visible = not $CanvasLayer.visible
