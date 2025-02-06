extends SingleCooldownIndicator


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	max_cooldown = PlayerState.chain_lightning_cooldown
	current_cooldown = PlayerState.chain_lightning_timer.time_left
	super(delta)
	
func player_has_skill() -> bool:
	return PlayerState.has_chain_lightning
