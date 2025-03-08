extends Panel
var texture : Texture2D = preload("res://icon.svg")
@export var text : String
@export var cost : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/MarginContainer2/TextureRect.texture = texture
	$VBoxContainer/MarginContainer/Label.text = text
	$VBoxContainer/MarginContainer3/Button.text = str(cost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
