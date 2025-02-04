class_name EagleEyeLogic
extends CommonUpgradeLogic

@export var view_distance_bonus : float = 0.2
@export var critical_chance_bonus : float = 0.1

func add_item_effect():
	PlayerState.view_distance_bonus -= view_distance_bonus
	PlayerState.critical_strike_chance_bonus += critical_chance_bonus

func available():
	return PlayerState.view_distance_bonus > -1.9 and PlayerState.critical_strike_chance_bonus < 0.9
