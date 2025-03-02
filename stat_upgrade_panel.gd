class_name StatUpgradePanel
extends Panel

@export var upgrade_type : PlayerState.UPGRADES
@export var upgrade_name : String
@export var cost : int
var texture : CompressedTexture2D = preload("res://icon.svg")


func _ready() -> void:
	$VBoxContainer/MarginContainer/Label.text = upgrade_name
	$VBoxContainer/MarginContainer3/Button.text = str(cost)
	$VBoxContainer/MarginContainer2/TextureRect.texture = texture
	checkAvailability()

func _process(_delta: float) -> void:
	checkAvailability()

func _on_button_pressed() -> void:
	PlayerState.coins_base -= cost
	PlayerState.add_upgrade(upgrade_type, 0)
	
func checkAvailability():
	$VBoxContainer/MarginContainer3/Button.disabled = PlayerState.coins_base < cost
