class_name NinjaStarLogic
extends CommonUpgradeLogic

func add_item_effect():
	PlayerState.choose_class(3)
	
func available() -> bool:
	return PlayerState.chosen_class != 3
