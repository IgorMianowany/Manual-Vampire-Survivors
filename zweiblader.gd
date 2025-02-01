class_name ZweibladerLogic
extends CommonUpgradeLogic

@export var damage_buff : float = 2
@export var attack_speed_debuff : float = .15

func add_item_effect():
	PlayerState.attack_speed += PlayerState.attack_speed * attack_speed_debuff
	PlayerState.attack_damage = PlayerState.attack_damage * damage_buff
