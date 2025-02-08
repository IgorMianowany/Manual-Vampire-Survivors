extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hitbox.monitorable = true
	$Hitbox.damage = PlayerState.lightning_strike_damage
	$LightningStrike.animation_finished.connect(strike_animation_finished)
	set_as_top_level(true)
		


func strike_animation_finished():
	queue_free()
