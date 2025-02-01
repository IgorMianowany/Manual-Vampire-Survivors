class_name UpgradeSelection
extends Panel

signal upgrade_selected

@export var icon : CompressedTexture2D
@export var description : String
@export var upgrade_name : String
@export var upgrade : PlayerState.UPGRADES
var upgrade_logic 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Description.text = description
	$VBoxContainer/MarginContainer4/Name.text = upgrade_name
	
func apply_upgrade():
	var upgrade_number = int(description.split(" ")[0].replace("+", "").replace("%", ""))
	PlayerState.add_upgrade(upgrade, upgrade_number)
	upgrade_selected.emit()
	

func _on_button_pressed() -> void:
	apply_upgrade()
	
func available() -> bool:
	return true
	
