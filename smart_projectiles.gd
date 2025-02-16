class_name SmartProjectilesLogic
extends CommonUpgradeLogic

func add_item_effect():
	PlayerState.has_homing_projectiles = true

func available() -> bool:
	return not PlayerState.has_homing_projectiles and PlayerState.chosen_class != 3
