class_name MuscularForearmLogic
extends CommonUpgradeLogic

@export var damage_bonus : float = 20
@export var view_distance_debuff : float = 0.5

func add_item_effect():
	PlayerState.attack_damage += damage_bonus
	PlayerState.view_distance_bonus += view_distance_debuff
	
func available() -> bool:
	return PlayerState.view_distance_bonus < 1.9
	
