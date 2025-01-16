class_name Bow
extends WeaponType

@export var attack_speed := .75
var arrow_scene := preload("res://arrow.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(damage : float, position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	attack_started.emit()
	var projectilesArray : Array[PackedScene]
	for index in projectiles:
		var existing_direction = direction # Example: 1 unit along the X axis
		# 15 degrees in radians
		var angle_in_radians = deg_to_rad((45/projectiles * index))
		# Rotate the existing direction by 15 degrees
		var new_direction = existing_direction.rotated(angle_in_radians)

		var projectile := arrow_scene.instantiate()
		projectile.position = position + direction * 15
		projectile.direction = new_direction
		projectile.damage = damage
		projectile.pierce = pierce
		add_child(projectile)
	await(get_tree().create_timer(attack_speed).timeout)
	attack_finished.emit()
	
