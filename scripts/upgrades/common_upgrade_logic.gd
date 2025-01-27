class_name CommonUpgradeLogic
extends UpgradeSelection

func _ready() -> void:
	upgrade = PlayerState.UPGRADES.MISC
	super()
	
func apply_upgrade():
	add_item_effect()
	super()

func add_item_effect():
	print("default item effect")
