class_name FireballNew
extends Projectile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FireballExplosionRadius.monitoring = false
	super()
	$ProjectileHitbox.damage = 0


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
	$Sprite2D.scale = Vector2(.3,.5)
	

func _on_projectile_death():
	await animate_explosion()
	super()


func _on_fireball_explosion_radius_area_entered(area: Area2D) -> void:
	var is_crit = $ProjectileHitbox.is_crit()
	var new_damage = damage + damage * ($ProjectileHitbox.crit_multi + PlayerState.critical_strike_damage_bonus) * int(is_crit)
	if area.owner.has_method("take_damage"):
		area.owner.take_damage(new_damage, global_position.direction_to(area.global_position), 2, PlayerState.has_poison_attacks, is_crit)
		
func _reusable_ready():
	$FireballExplosionRadius.monitoring = false
	super()
