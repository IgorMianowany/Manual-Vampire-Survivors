class_name ProjectileUpgradeLogic
extends CommonUpgradeLogic

func add_item_effect():
	PlayerState.projectiles += 1
	PlayerState.pierce += 1
	
