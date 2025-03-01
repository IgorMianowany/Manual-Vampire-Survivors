extends Control
var level_scene := preload("res://level_01.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_start_button_pressed() -> void:
	PlayerState.reset_bonus_stats()
	get_tree().change_scene_to_file("res://level_01.tscn")

func _on_option_button_pressed() -> void:
	get_tree().change_scene_to_file("res://stat_upgrade_menu.tscn")
