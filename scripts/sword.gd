class_name Sword
extends WeaponType
var attack_time : float = .5
var knockback_power : float = 1
var timer : Timer
@export var attack_range_pointer : Node2D
@export var attack_shape_cast : ShapeCast2D
@export var hitbox : Hitbox
@export var hitboxShape : CollisionShape2D

func attack(attack_damage : float, attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	attack_started.emit()
	
	await(get_tree().create_timer(0.15).timeout)
	hitboxShape.disabled = false
	
	attack_shape_cast.target_position = attack_range_pointer.position
	for index in attack_shape_cast.get_collision_count():
		var enemy = attack_shape_cast.get_collider(index)
		enemy.take_damage(attack_damage, attack_position.direction_to(enemy.position), knockback_power)
		
	await(get_tree().create_timer(attack_time).timeout)
	attack_finished.emit()
	hitboxShape.disabled = true	
