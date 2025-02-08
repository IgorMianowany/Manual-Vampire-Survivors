extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Hitbox.monitorable = true
	$LightningStrike.animation_finished.connect(strike_animation_finished)
	for enemy in $Hitbox.get_overlapping_bodies():
		(enemy as Slime).take_damage($Hitbox.damage, Vector2.ZERO, 0)
	set_as_top_level(true)
		


func strike_animation_finished():
	queue_free()
