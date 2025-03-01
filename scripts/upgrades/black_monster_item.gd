class_name BlackMonsterLogic
extends WhiteMonsterLogic

func add_item_effect():
	PlayerState.set_max_health(-50)
	super()
	
