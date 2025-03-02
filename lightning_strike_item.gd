class_name UpgradeStrikeLogic
extends CommonUpgradeLogic

func add_item_effect():
	PlayerState.lightning_strike_cooldown -= 1
	PlayerState.lightning_strike_damage += 5
	if PlayerState.lightning_strike_range == 0:
		PlayerState.lightning_strike_range = 50
		PlayerState.lightning_strike_cooldown = 10
	else:
		PlayerState.lightning_strike_range += 20
	PlayerState.add_lightning_strike_item()
	
