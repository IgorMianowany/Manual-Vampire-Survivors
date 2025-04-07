class_name NinjaUpgradePanel
extends StatUpgradePanel

func _ready() -> void:
	cost = 50
	$VBoxContainer/MarginContainer/HBoxContainer/Label.text = upgrade_name
	$VBoxContainer/MarginContainer3/Button.text = str(cost)
	$VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/TextureRect.texture = texture
	checkAvailability()
	
func _on_button_pressed() -> void:
	PlayerState.coins_base -= cost
	PlayerState.ninja_unlocked_base = true
	# accessing style boxes from code is hard, this is easier
	$VBoxContainer/MarginContainer3/Button.text = "Owned    "
	$VBoxContainer/MarginContainer3/Button.icon = null
	checkAvailability()

func checkAvailability():
	$VBoxContainer/MarginContainer3/Button.disabled = not(not PlayerState.ninja_unlocked_base and PlayerState.coins_base > cost)
