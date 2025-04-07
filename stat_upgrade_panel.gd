class_name StatUpgradePanel
extends Panel

@export var upgrade_type : PlayerState.UPGRADES
@export var upgrade_name : String
@export var cost : int
var texture : CompressedTexture2D = preload("res://icon.svg")


func _ready() -> void:
	$VBoxContainer/MarginContainer/HBoxContainer/Label.text = upgrade_name
	$VBoxContainer/MarginContainer3/Button.text = str(cost)
	$VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/TextureRect.texture = texture
	reset_upgrade_values()
	checkAvailability()

func _process(_delta: float) -> void:
	checkAvailability()

func _on_button_pressed() -> void:
	PlayerState.coins_base -= cost
	PlayerState.add_upgrade(upgrade_type, 0)
	reset_upgrade_values()
	
func checkAvailability():
	$VBoxContainer/MarginContainer3/Button.disabled = PlayerState.coins_base < cost
	
func reset_upgrade_values():
	$VBoxContainer/MarginContainer2/HBoxContainer/CurrentValue.text = str(PlayerState.get_current_upgrade_value(upgrade_type))
	$VBoxContainer/MarginContainer2/HBoxContainer/NewValue.text = str(PlayerState.get_new_upgrade_value(upgrade_type))
