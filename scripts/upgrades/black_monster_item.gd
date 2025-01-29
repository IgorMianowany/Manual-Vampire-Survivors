class_name BlackMonsterLogic
extends WhiteMonsterLogic

func add_item_effect():
	PlayerState.max_health -= 50

	super()
	
