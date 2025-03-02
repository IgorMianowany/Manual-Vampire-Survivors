extends Control

@export var class_amount : int = 5
@onready var class_container = $CanvasLayer/HBoxContainer

func _ready() -> void:
	$CanvasLayer/HBoxContainer/Ninja.visible = PlayerState.ninja_unlocked_base
	get_tree().paused = true
	for node in class_container.get_children():
		node.class_selected.connect(_quit)

func _quit():
	get_tree().paused = false
	queue_free()

func _class_selection_visible():
	add_child($CanvasLayer)
