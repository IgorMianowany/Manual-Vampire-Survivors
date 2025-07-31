class_name LightSkeletonArcher
extends LightEnemy

signal attack_signal

var projectile_speed : float = 100
var current_speed : float = 0
var current_position : Vector2 = Vector2.ZERO
var previous_position : Vector2

func _ready() -> void:
	super()
	animated_sprite_2d = $Position/SkeletonAnimatedSprite2D
	attack_signal.connect(attack)

func _physics_process(delta: float) -> void:
	previous_position = current_position
	current_position = get_pos()
	current_speed = current_position.distance_to(previous_position)
	super(delta)
	
	#var trans = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
	#velocity = trans.origin.direction_to(player.position) * speed * delta
	#var next_position : Vector2 = trans.origin + velocity * delta
	#trans = Transform2D(0, next_position)
	#$Position.global_position = trans.origin
	#PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)
	#RenderingServer.canvas_item_set_transform(img, trans)
	
func _process(delta: float) -> void:
	if current_speed == 0 and not is_attacking:
		attack()
	super(delta)
	

func attack():
	if not is_attacking:
		is_attacking = true
		var attack_projectile = PlayerState.enemy_projectile_bench.pop_front()
		#add_child(attack_projectile)
		if attack_projectile == null:
			return
		attack_projectile.active = true
		attack_projectile.global_position = global_position + direction * 15
		attack_projectile.direction = global_position.direction_to(player.global_position)
		attack_projectile.damage = 10
		attack_projectile.velocity = projectile_speed * attack_projectile.direction
		attack_projectile._reusable_ready()
		await(get_tree().create_timer(1.25 + variation * 10).timeout)
		is_attacking = false


func _on_skeleton_animated_sprite_2d_animation_finished() -> void:
	_on_animation_finished(animated_sprite_2d.animation)
