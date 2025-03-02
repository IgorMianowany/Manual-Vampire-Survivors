extends Control

@onready var main_menu_scene := preload("res://start_menu.tscn")

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
