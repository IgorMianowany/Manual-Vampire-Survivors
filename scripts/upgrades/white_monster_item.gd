class_name WhiteMonsterLogic
extends CommonUpgradeLogic

@export var movespeed_buff : float = 25
@export var attack_speed_buff : float = .15

func add_item_effect():
	PlayerState.attack_speed -= PlayerState.attack_speed * attack_speed_buff
	PlayerState.movespeed_bonus += movespeed_buff
