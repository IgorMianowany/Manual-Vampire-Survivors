class_name Bow
extends WeaponType

@export var attack_speed := 2.0
var arrow_scene := preload("res://arrow.tscn")

func attack(damage : float, attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO, crit_chance : float = 0, crit_multi : float = 0) -> void:
	attack_started.emit()
	for index in projectiles:
		var existing_direction = direction
		# this is done so the arrows are moved based on the center, instead of just 45 degrees down or up
		if projectiles > 1:
			@warning_ignore("integer_division")
			rotation_change = ((-spread/2) + ((spread/(projectiles-1)) * index))
		var angle_in_radians = deg_to_rad(rotation_change)
		var new_direction = existing_direction.rotated(angle_in_radians)

		#var projectile := arrow_scene.instantiate()
		var projectile = PlayerState.projectile_bench.pop_front()
		if projectile == null:
			projectile = arrow_scene.instantiate()
		else:
			projectile.reparent(self)
		$ShapeCast2D.target_position = get_local_mouse_position()
		projectile.active = true
		projectile.global_position = attack_position + direction * 15
		projectile.direction = new_direction.normalized()
		projectile.start_position = global_position
		projectile.damage = PlayerState.attack_damage
		projectile.pierce = pierce
		projectile.crit_chance = crit_chance
		projectile.crit_multi = crit_multi
		projectile._reusable_ready()
		#add_child(projectile)
	await(get_tree().create_timer(PlayerState.attack_speed).timeout)
	attack_finished.emit()
	
