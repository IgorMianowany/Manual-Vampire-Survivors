extends Projectile

func _ready() -> void:
	set_as_top_level(true)
	$ProjectileHitbox.knockback_power = 0
	$Timer.start(lifetime)

func _process(delta: float) -> void:
	damage = 0
	$Sprite2D.rotate(.6 * delta)
	global_position += direction * delta * speed

func _on_gravitation_pull_range_area_entered(area: Area2D) -> void:
	var slime = (area.owner as LightEnemy)
	if slime.pull_source == null:
		slime.is_pulled = true
		slime.pull_source = self

func _on_gravitation_pull_range_area_exited(area: Area2D) -> void:
	(area.owner as LightEnemy).is_pulled = false
	(area.owner as LightEnemy).pull_source = null


func _on_recast_timer_timeout() -> void:
	$ProjectileHitbox/CollisionShape2D.disabled = true
	$ProjectileHitbox/CollisionShape2D.disabled = false
	$GravitationPullRange/CollisionShape2D.disabled = true
	$GravitationPullRange/CollisionShape2D.disabled = false
