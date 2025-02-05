class_name ChainLightningLogic
extends CommonUpgradeLogic
@export var chain_lightning_damage_bonus : float = 1
@export var chain_lightning_max_hits_bonus : int = 1
@export var chain_lightning_cooldown_decrease : float = .5

func add_item_effect():
	PlayerState.get_chain_lightning()
	#PlayerState.chain_lightning_damage += chain_lightning_damage_bonus
	PlayerState.chain_lightning_damage += 0
	PlayerState.chain_lightning_max_hits += chain_lightning_max_hits_bonus
	PlayerState.chain_lightning_cooldown -= chain_lightning_cooldown_decrease
