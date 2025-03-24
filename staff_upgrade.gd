class_name StaffUpgradePanel
extends StatUpgradePanel

func _ready() -> void:
	cost = 50
	$VBoxContainer/MarginContainer/Label.text = upgrade_name
	$VBoxContainer/MarginContainer3/Button.text = str(cost)
	$VBoxContainer/MarginContainer2/TextureRect.texture = texture
	checkAvailability()
	
func _on_button_pressed() -> void:
	PlayerState.coins_base -= cost
	PlayerState.staff_level_base += 1
	# accessing style boxes from code is hard, this is easier
	#$VBoxContainer/MarginContainer3/Button.text = "Owned    "
	#$VBoxContainer/MarginContainer3/Button.icon = null
	checkAvailability()

func checkAvailability():
	$VBoxContainer/MarginContainer3/Button.disabled = PlayerState.coins_base < cost
