class_name HolyExplosion
extends CommonSkill

var damage : float = 1
var direction : Vector2


func _ready() -> void:
	set_as_top_level(true)
	global_position = get_global_mouse_position()
	$Hitbox/CollisionPolygon2D.disabled = false
	await(get_tree().create_timer(.5).timeout)
	$Hitbox/CollisionPolygon2D.disabled = true
	queue_free()
	
func set_skill_stats():
	$Hitbox.damage = damage
