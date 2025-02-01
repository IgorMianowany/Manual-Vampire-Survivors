class_name FireballNew
extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FireballExplosionRadius.monitoring = false
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)

func animate_explosion():
	$FireballExplosionRadius.monitoring = true
	speed = 0
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		$Sprite2D, "scale", Vector2(2, 5), .2
	)
	await tween.finished
	queue_free()


func _on_projectile_death():
	animate_explosion()


func _on_fireball_explosion_radius_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage, global_position.direction_to(area.global_position), 2, PlayerState.has_poison_attacks)
