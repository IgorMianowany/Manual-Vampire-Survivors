class_name Bow
extends WeaponType

@export var attack_speed := .75
@export var spread := 30
var arrow_scene := preload("res://arrow.tscn")
var rotation_change := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(damage : float, position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	attack_started.emit()
	var projectilesArray : Array[PackedScene]
	var original_projectiles = projectiles
	for index in projectiles:
		var existing_direction = direction
		# this is done so the arrows are moved based on the center, instead of just 45 degrees down or up
		if projectiles > 1:
			rotation_change = ((-spread/2) + ((spread/(projectiles-1)) * index))
		var angle_in_radians = deg_to_rad(rotation_change)
		var new_direction = existing_direction.rotated(angle_in_radians)

		var projectile := arrow_scene.instantiate()
		projectile.position = position + direction * 15
		projectile.direction = new_direction
		projectile.damage = damage
		projectile.pierce = pierce
		add_child(projectile)
	await(get_tree().create_timer(attack_speed).timeout)
	attack_finished.emit()
	
