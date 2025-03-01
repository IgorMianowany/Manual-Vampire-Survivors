extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	$HBoxContainer/Label.text = str(PlayerState.coins_base)
