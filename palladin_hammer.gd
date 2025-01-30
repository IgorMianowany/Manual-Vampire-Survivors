class_name PalladinHammerLogic
extends CommonUpgradeLogic

@export var damage : float = 5
@export var speed : float = .005

func add_item_effect():
	PlayerState.palladin_hammer_counter += 1
	PlayerState.palladin_hammer_damage += damage
	PlayerState.palladin_hammer_speed += speed
	PlayerState.add_palladin_hammer.emit()
