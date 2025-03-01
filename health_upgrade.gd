class_name HealthUpgradeLogic
extends CommonUpgradeLogic

@export var health_buff : float = 100

func add_item_effect():
	var health_percantage = PlayerState.get_current_health() / PlayerState.get_max_health()
	PlayerState.set_max_health(health_buff)
	PlayerState.set_current_health(int(PlayerState.get_max_health() * health_percantage))

func available() -> bool:
	return true
