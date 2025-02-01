class_name SpinachLogic
extends CommonUpgradeLogic

@export var attack_damage_buff : float = 15

func add_item_effect():
	PlayerState.attack_damage += attack_damage_buff
