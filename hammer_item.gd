class_name HammerLogic
extends CommonUpgradeLogic

@export var damage : float = 5
@export var knockback : float = 5

func add_item_effect():
	PlayerState.attack_damage += damage
	PlayerState.knockback_bonus += knockback
