class_name Sword
extends WeaponType
var attack_time : float = .5
var knockback_power : float = 1
var timer : Timer
var slash_scene := preload("res://sword_slash_new.tscn")
var sword_projectiles : int
var crit_chance : float
var crit_multi : float
@export var attack_range_pointer : Node2D
@export var attack_shape_cast : ShapeCast2D
@export var hitbox : Hitbox
@export var hitboxShape : CollisionShape2D

func attack(attack_damage : float, attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO, crit_chance : float = 0, crit_multi : float = 0) -> void:
	sword_projectiles = projectiles - 1
	attack_started.emit()
	# timeout to account for attack starting with delay, animation specific
	await(get_tree().create_timer(0.15).timeout)
	hitboxShape.disabled = false
	
	attack_shape_cast.target_position = attack_range_pointer.position
	var is_crit = randf_range(0,1) < crit_chance
	var damage = attack_damage + attack_damage * crit_multi * int(is_crit)
	for index in attack_shape_cast.get_collision_count():
		var enemy = attack_shape_cast.get_collider(index)
		enemy.take_damage(damage, attack_position.direction_to(enemy.position), knockback_power + PlayerState.knockback_bonus, false, is_crit)
	#if sword_projectiles > 0:
	for index in sword_projectiles:
		var existing_direction = direction
		# this is done so the arrows are moved based on the center, instead of just 45 degrees down or up
		if sword_projectiles > 1:
			rotation_change = ((-spread/2) + ((spread/(sword_projectiles-1)) * index))
		var angle_in_radians = deg_to_rad(rotation_change)
		var new_direction = existing_direction.rotated(angle_in_radians)

		var projectile := slash_scene.instantiate()
		projectile.position = attack_position + direction * 15
		projectile.direction = new_direction
		projectile.damage = PlayerState.attack_damage
		projectile.pierce = pierce
		projectile.crit_chance = crit_chance
		projectile.crit_multi = crit_multi
		add_child(projectile)
		
	await(get_tree().create_timer(attack_time).timeout)
	attack_finished.emit()
	hitboxShape.disabled = true	
