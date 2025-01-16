class_name Bow
extends WeaponType

@export var attack_speed := .75
var arrow_scene := preload("res://arrow.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(damage : float, position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	attack_started.emit()
	var projectile := arrow_scene.instantiate()
	projectile.position = position + direction * 15
	projectile.direction = direction
	projectile.damage = damage
	projectile.pierce = pierce
	add_child(projectile)
	await(get_tree().create_timer(attack_speed).timeout)
	attack_finished.emit()
	
