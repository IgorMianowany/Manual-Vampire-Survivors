class_name HourglassLogic
extends CommonUpgradeLogic

@export var projectile_slow_multiplier : float = 10
@export var projectile_lifetime : float = 10
@export var damage_buff : float = 10

func add_item_effect():
	PlayerState.set_projectile_speed(-(PlayerState.get_projectile_speed() * (1 - 1/projectile_slow_multiplier)))
	PlayerState.projectile_lifetime = projectile_lifetime
	PlayerState.set_attack_damage(damage_buff)
