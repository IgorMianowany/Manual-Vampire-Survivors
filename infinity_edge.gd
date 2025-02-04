class_name InfinityEdge
extends CommonUpgradeLogic

@export var crit_chance_buff : float = 0.25
@export var crit_damage_buff : float = 0.4

func add_item_effect():
	PlayerState.critical_strike_chance_bonus += crit_chance_buff
	PlayerState.critical_strike_damage_bonus += crit_damage_buff
	
func available() -> bool:
	return PlayerState.critical_strike_chance_bonus < 0.8
	
