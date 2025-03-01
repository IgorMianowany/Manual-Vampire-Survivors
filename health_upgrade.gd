class_name HealthUpgradeLogic
extends CommonUpgradeLogic

@export var health_buff : float = 100

func add_item_effect():
	var health_percantage = PlayerState.health / PlayerState.max_health
	PlayerState.max_health += health_buff
	PlayerState.health = int(PlayerState.max_health * health_percantage)

func available() -> bool:
	return true
