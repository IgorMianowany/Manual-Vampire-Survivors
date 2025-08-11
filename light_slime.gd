class_name LightSlime
extends LightEnemy


signal change_anim

func _ready() -> void:
	animated_sprite_2d = $Position/AnimatedSprite2D
	change_anim.connect(handle_change_animation)
	variation = randf_range(-1, 1)
	col_layer = 9
	super()
	
func _process(delta: float) -> void:
	if not active:
		return
	jump_timer -= delta
	if is_pulled:
		speed = 2000
	elif jump_timer < 0:
		direction_update_cooldown = 2
		speed = 3000 if speed == 0 else 0
		jump_timer = 1.5 + variation
		velocity = get_pos().direction_to(player.position) * speed * delta
		change_anim.emit()
	super(delta)
	
func _physics_process(delta: float) -> void:
	super(delta)
	
func _manual_spawn_ready():
	animated_sprite_2d = $Position/AnimatedSprite2D
	active = true
	$Position/Hitbox.collision_layer = 32
	super()
	
func handle_change_animation():
	if hp < 0:
		return
	if speed == 0:
		animated_sprite_2d.play("idle_down")
	else:
		animated_sprite_2d.play("move_down")
