extends Panel

signal class_selected

@export var icon : CompressedTexture2D
@export var description : String
@export var class_number : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label.text = description
	
func apply_upgrade():
	PlayerState.choose_class(class_number)
	class_selected.emit()
	

func _on_button_pressed() -> void:
	apply_upgrade()
