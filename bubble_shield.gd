class_name BubbleShieldLogic
extends CommonUpgradeLogic

@export var nubmer_of_hits : float = 1
@export var cooldown : float = 15

func add_item_effect():
	PlayerState.has_bubble_shield_upgrade = true
	PlayerState.bubble_shield_cooldown = cooldown
	PlayerState.bubble_shield_max_hits += nubmer_of_hits
	PlayerState.add_bubble_shield.emit()
