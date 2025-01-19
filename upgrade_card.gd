extends Panel

signal upgrade_selected

@export var icon : CompressedTexture2D
@export var description : String
@export var upgrade : PlayerState.UPGRADES

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/MarginContainer/TextureRect.texture = icon
	$VBoxContainer/MarginContainer2/Label.text = description
	
func apply_upgrade():
	var upgrade_number = int(description.split(" ")[0].replace("+", "").replace("%", ""))
	PlayerState.add_upgrade(upgrade, upgrade_number)
	upgrade_selected.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
