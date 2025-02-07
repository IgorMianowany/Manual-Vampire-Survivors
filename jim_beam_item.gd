class_name JimBeamLogic
extends CommonUpgradeLogic

@export var damage_multi : float = 2
@export var max_hp : float = 50


func add_item_effect():
	#PlayerState.attack_damage *= damage_multi
	#PlayerState.max_health += max_hp
	PlayerState.jim_beam_counter += 1
	PlayerState.jim_beam_drank.emit()
