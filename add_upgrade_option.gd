class_name AddUpgradeOptionLogic
extends CommonUpgradeLogic

func add_item_effect():
	PlayerState.upgrades_amount += 1
	
func available() -> bool:
	return PlayerState.upgrades_amount < 4
