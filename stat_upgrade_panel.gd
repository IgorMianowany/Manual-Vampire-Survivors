class_name StatUpgradePanel
extends Panel

@export var upgrade_type : PlayerState.UPGRADES
@export var upgrade_name : String
@export var cost : int

func _ready() -> void:
	$VBoxContainer/MarginContainer/Label.text = upgrade_name
	$VBoxContainer/MarginContainer3/Button.text = str(cost)

func _on_button_pressed() -> void:
	PlayerState.add_upgrade(upgrade_type, 0)
