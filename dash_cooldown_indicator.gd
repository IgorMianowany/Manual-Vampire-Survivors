extends SingleCooldownIndicator

func _process(delta: float) -> void:
	max_cooldown = PlayerState.dash_cooldown
	current_cooldown = PlayerState.dash_timer.time_left
	super(delta)
	
func player_has_skill() -> bool:
	return PlayerState.has_dash
