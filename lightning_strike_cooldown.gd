extends SingleCooldownIndicator

func _ready() -> void:
	current_cooldown = PlayerState.lightning_strike_cooldown
	max_cooldown = PlayerState.lightning_strike_cooldown
	

func _process(delta: float) -> void:
	current_cooldown -= delta
	super(delta)
	
func player_has_skill() -> bool:
	return false
