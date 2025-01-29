class_name HermesBootsLogic
extends CommonUpgradeLogic

@export var movespeed_buff : float = 50

func add_item_effect():
	PlayerState.movespeed_bonus += movespeed_buff
