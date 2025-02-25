class_name JimBeamLogic
extends CommonUpgradeLogic

@export var damage_multi : float = 2
@export var max_hp : float = 50


func add_item_effect():
	PlayerState.jim_beam_counter += 1
	PlayerState.jim_beam_drank.emit()
