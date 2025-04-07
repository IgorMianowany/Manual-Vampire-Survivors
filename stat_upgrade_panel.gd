class_name StatUpgradePanel
extends Panel

@export var upgrade_type : PlayerState.UPGRADES
@export var upgrade_name : String
@export var cost : int
var texture : CompressedTexture2D = preload("res://icon.svg")
var still_available : bool = true


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
	checkAvailability()
	
func checkAvailability():
	$VBoxContainer/MarginContainer3/Button.disabled = PlayerState.coins_base < cost or not still_available
	if $VBoxContainer/MarginContainer3/Button.disabled:
		cost = 0
		$VBoxContainer/MarginContainer3/Button.text = str(cost)
	
func reset_upgrade_values():
	var new_value = PlayerState.get_new_upgrade_value(upgrade_type)
	$VBoxContainer/MarginContainer2/HBoxContainer/CurrentValue.text = str(PlayerState.get_current_upgrade_value(upgrade_type))
	$VBoxContainer/MarginContainer2/HBoxContainer/NewValue.text = str(PlayerState.get_new_upgrade_value(upgrade_type))
	if new_value == 0:
		for child in $VBoxContainer/MarginContainer2/HBoxContainer.get_children():
			(child as Label).text = ""
		$VBoxContainer/MarginContainer2/HBoxContainer/NewValue.text = "MAX"
		still_available = false
