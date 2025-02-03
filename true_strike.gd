class_name TrueStrikeLogic
extends CommonUpgradeLogic

var crit_chance_buff : float = 0.1

func add_item_effect():
	PlayerState.critical_strike_bonus += crit_chance_buff
	
func available() -> bool:
	return PlayerState.critical_strike_bonus < 0.8
