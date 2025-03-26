extends Projectile

func _ready() -> void:
	set_as_top_level(true)
	$ProjectileHitbox.knockback_power = 0
	$Timer.start(lifetime)

func _process(delta: float) -> void:
	print($Timer.time_left)
	$Sprite2D.rotate(.6 * delta)
	global_position += direction * delta * speed

func _on_gravitation_pull_range_area_entered(area: Area2D) -> void:
	(area.owner as Slime).is_pulled = true
	(area.owner as Slime).pull_source = self

func _on_gravitation_pull_range_area_exited(area: Area2D) -> void:
	(area.owner as Slime).is_pulled = false
	(area.owner as Slime).pull_source = null
