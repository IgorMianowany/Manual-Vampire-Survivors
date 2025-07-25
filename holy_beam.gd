class_name HolyBeam
extends CommonSkill

var shape_x : float
var damage : float = 1
var speed : float = 32
var direction : Vector2
var duration : float = 0
var max_duration : float = 0.4

func _ready() -> void:
	set_as_top_level(true)
	$Hitbox/CollisionShape2D.disabled = false

	
func set_skill_stats():
	global_position = player_position
	direction = global_position.direction_to(get_global_mouse_position())
	$Hitbox.damage = damage
	cost = 100
	look_at(global_position + direction)
	
	
func _physics_process(delta: float) -> void:
	duration+=delta
	if(duration>max_duration):
		$Hitbox/CollisionShape2D.disabled = true
	if $Hitbox/CollisionShape2D.shape.size.x > 460:
		return
	$Hitbox/CollisionShape2D.shape.size.x += speed
	$Hitbox/CollisionShape2D.position.x += speed / 2
	


func _on_animated_sprite_2d_animation_finished() -> void:
	$Hitbox/CollisionShape2D.disabled = true
	$Hitbox/CollisionShape2D.shape.size = Vector2(24, 28)
	queue_free()
