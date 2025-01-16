class_name Sword
extends WeaponType
var attack_time : float = .5
var damage : float 
var knockback_power : float = 1
var timer : Timer
@export var attack_range_pointer : Node2D
@export var attack_shape_cast : ShapeCast2D
@export var hitbox : Hitbox
@export var hitboxShape : CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack(damage : float, position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO) -> void:
	attack_started.emit()
		
	
	await(get_tree().create_timer(0.15).timeout)
	hitboxShape.disabled = false
	#timer.start(attack_time)
		

	attack_shape_cast.target_position = attack_range_pointer.position
	for index in attack_shape_cast.get_collision_count():
		var enemy = attack_shape_cast.get_collider(index)
		enemy.take_damage(damage, position.direction_to(enemy.position), knockback_power)
		
		
	await(get_tree().create_timer(attack_time).timeout)
	#await(timer.timeout)
	attack_finished.emit()
	hitboxShape.disabled = true	
