class_name PalladinHammerLogic
extends CommonUpgradeLogic

@export var damage : float = 5
@export var knockback : float = 5

func add_item_effect():
	PlayerState.palladin_hammer_counter += 1
	PlayerState.add_palladin_hammer.emit()
