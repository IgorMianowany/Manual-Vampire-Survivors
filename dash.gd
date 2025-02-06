class_name DashLogic
extends CommonUpgradeLogic

@export var dash_cooldown_reduction : float = 0.5
@export var dash_damage_bonus : float = 5

func add_item_effect():
	PlayerState.has_dash = true
