class_name PoisonVialLogic
extends CommonUpgradeLogic

@export var damage : float = 1
@export var duration : float = 5

func add_item_effect():
	PlayerState.has_poison_attacks = true
	PlayerState.poison_damage += damage
	PlayerState.poison_duration += duration
