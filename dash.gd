class_name DashLogic
extends CommonUpgradeLogic

@export var dash_cooldown_reduction : float = 0.5
@export var dash_damage_bonus : float = 5

func add_item_effect():
	if PlayerState.has_dash:
		PlayerState.dash_damage += dash_damage_bonus
		PlayerState.dash_cooldown = clampf(PlayerState.dash_cooldown - dash_cooldown_reduction, 2, PlayerState.dash_cooldown)
	else:
		PlayerState.has_dash = true
		PlayerState.dash_cooldown = 1
		PlayerState.dash_damage = PlayerState.attack_damage
