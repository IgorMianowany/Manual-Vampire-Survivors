class_name KnifeLogic
extends CommonUpgradeLogic

func add_item_effect():
	PlayerState.add_knife.emit()
	PlayerState.has_knife = true
	
func available() -> bool:
	return not PlayerState.has_knife
