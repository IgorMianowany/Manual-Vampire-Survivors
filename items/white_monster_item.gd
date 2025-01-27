class_name WhiteMonsterLogic
extends UpgradeSelection

@export var movespeed_buff : float = 5
@export var attack_speed_buff : float = .15

func _ready() -> void:
	upgrade = PlayerState.UPGRADES.MISC
	super()
func apply_upgrade():
	add_item_effect()
	super()

func add_item_effect():
	PlayerState.attack_speed -= PlayerState.attack_speed * attack_speed_buff
	PlayerState.movespeed_bonus += movespeed_buff
	
