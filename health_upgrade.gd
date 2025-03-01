class_name HealthUpgradeLogic
extends CommonUpgradeLogic

@export var health_buff : float = 100

func add_item_effect():
	PlayerState.set_max_health(health_buff)

func available() -> bool:
	return true
