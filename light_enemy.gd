class_name LightEnemy
extends Node2D

var object : RID
var img : RID


@export var player : Player
@export var speed : float = 250
#@export var speed : float = 0
@export var jump_cooldown : float = 1.5
@export var jump_duration : float = .9
@export var jump_variation : float = 0.5
@export var direction_variation : float = 15
@export var damage : float = 10
@export var knockback_power : float = 1
@export var max_health : float = 10 
@export var exp_amount : int = 1
@export var healthbar : TextureProgressBar
@export var money : int = 100 
@onready var health : float = max_health
@onready var experience_pickup := preload("res://experience_pickup.tscn")
var player_direction : Vector2
var jump_timer : float = 0
var direction : Vector2 = Vector2.ZERO
var player_position : Vector2
var is_jumping : bool = false
var is_dead : bool = false
enum DirectionEnum {UP, DOWN, LEFT, RIGHT}
var facing_direction : DirectionEnum
var is_knocked_back : bool = false
var is_poisoned : bool = false
var poison_damage : float = 0
var poison_ticks_left : float = 0
var already_hit_by_chain_lightning : bool = false
var is_first_hit_by_chain_lightning : bool = false
var variation : float
var active : bool = false
var is_pulled : bool = false
var pull_source : Node2D = null
var boids_i_see : Array[Enemy] = []
var screensize : Vector2
var movv := 48
var sprite : AnimatedSprite2D
var repulsion_force : float = 0.1
var collision_calc_cooldown : int = 0
var is_attacking : bool = false
var distance_to_player : float
var frame_counter : int = 15
var color : Color = Color.WHITE
var transformed_position : Vector2 = Vector2.ZERO
var animated_sprite_2d : AnimatedSprite2D



@export var test_name : String

@onready var start_pos : Vector2 = position
@onready var chain_lightning_shape_cast = $Position/ChainLightningShapeCast
@onready var chain_lightning_animation = $Position/ChainLightningAnimation
@onready var collision_shape = CircleShape2D.new()
@export var tex : Texture2D

var hp : float = 100
var velocity : Vector2

func get_pos() -> Vector2:
	if $Position != null:
		return $Position.global_position
	return Vector2.ZERO
	
func _ready() -> void:
	collision_shape.radius = 8
	var ps = PhysicsServer2D
	object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, collision_shape)
	ps.body_add_collision_exception(object, player)
	ps.body_set_param(object, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0)
	ps.body_set_collision_layer(object, 5)
	
	#var transform = Transform2D(0, Vector2(250, 250))
	var trans = Transform2D(0, Vector2.ZERO)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, trans)
	
	var rs = RenderingServer
	img = rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	#rs.canvas_item_add_texture_rect(img, Rect2(Vector2(-8, -8),Vector2(16,16)), tex)
	#rs.canvas_item_set_transform(img, trans)
	
func _process(delta: float) -> void:
	if hp < 0:
		return
	jump_timer += delta
	transformed_position = $Position.global_position


func _physics_process(delta: float) -> void:
	if hp < 0:
		return
	var trans = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
	velocity = trans.origin.direction_to(player.position) * speed * delta
	var next_position : Vector2 = trans.origin + velocity * delta
	trans = Transform2D(0, next_position)
	$Position.global_position = trans.origin
	PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)
	RenderingServer.canvas_item_set_transform(img, trans)

	
func _exit_tree() -> void:
	PhysicsServer2D.free_rid(object)
	#RenderingServer.free_rid(img)
	
func set_enemy_position(pos : Vector2):
	var trans = Transform2D(0, pos)

	#RenderingServer.canvas_item_set_transform(img, trans)
	PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)

func take_damage(damage : float, direction : Vector2, knockback_power : float, is_poison : bool = false, is_crit : bool = false):
	damage = damage * 150
	hp -= damage

	var tween : Tween = create_tween()
	tween.tween_property(animated_sprite_2d, "modulate:v", 1, 0.1).from(15)
	
	DamageNumbers.display_number(int(damage * 15), $Position/DamageNumbersOrigin.global_position, is_crit, $Position/Label)

	#$Position/HitParticles.emitting = true
	#$Position/HitParticles.set_direction(direction)

	if PlayerState.chain_lightning_ready:
		if PlayerState.enemies_hit_by_chain_lightning.size() == 0:
			PlayerState.start_chain_lightning_timer()
		handle_chain_lightning_logic()
	#$Position/Control/Healthbar.health = hp
	if hp < max_health:
		$Position/SlimeHitbox.collision_layer = 0
		animated_sprite_2d.play("die")

	
func jump_toward_player(_jump_variation : float) -> void:
	if not jump_timer > jump_cooldown + _jump_variation or is_jumping:
		return
	var new_direction := Vector2.ZERO
	if jump_timer < jump_cooldown + jump_duration + _jump_variation and health > 0:
		is_jumping = true
		repulsion_force = .1
		$Position/SlimeHitbox/CollisionShape2D.disabled = false
		player_position = player.global_position + Vector2(randf_range(-direction_variation, direction_variation), randf_range(-direction_variation, direction_variation))

		if not is_knocked_back:
			new_direction = position.direction_to(player_position)
			animated_sprite_2d.play("move_down")
			# this is a weird way to check if slime reached it's jump destination before finishing the jump
			# in this case it will go back and forth trying to reach exactly this point, instead of keeping the momentum
			# this fixes that case
			if player_direction + new_direction < Vector2(0.001, 0.001) and player_direction + new_direction > Vector2(-0.001, -0.001):
				return
			velocity = $Position.global_position.direction_to(player_position) * speed
		else:
			is_jumping = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
		jump_timer = 0
		$Position/SlimeHitbox/CollisionShape2D.disabled = true
		repulsion_force = 0
		velocity = Vector2.ZERO
	player_direction = new_direction
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	_on_animation_finished(animated_sprite_2d.animation)
	is_jumping = false
	animated_sprite_2d.play("idle_down")
	
	
func _on_animation_finished(anim_name : StringName):
	if anim_name == "die":
		if PlayerState.experience_pickup_bench.size() != 0:
			var experience_pickup_new = PlayerState.experience_pickup_bench.pop_front()
			experience_pickup_new.reset($Position.global_position)
		#experience_pickup_new.turn_on_collision()
		#experience_pickup_new.global_position = global_position
		#experience_pickup_new.player = null
		#experience_pickup_new.active = true
		#experience_pickup_new.speed = 10000
		#PlayerState.active_enemies_count -= 2
		PlayerState.coins_base += money
		queue_free()
	is_jumping = false
	animated_sprite_2d.play("idle_down")
	
	
func _on_tree_exiting() -> void:
	PlayerState.active_enemies_count -= 1
	
	
func handle_chain_lightning_logic():
	chain_lightning_animation.set_process(true)
	chain_lightning_shape_cast.enabled = true
	chain_lightning_animation.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	await(get_tree().create_timer(.1).timeout)
	
	
	chain_lightning_shape_cast.shape.radius = PlayerState.chain_lightning_range
	# to niżej musi być poza ifem jakoś
	PlayerState.start_chain_lightning_timer()
	if not PlayerState.light_enemies_hit_by_chain_lightning.has(self):
		if PlayerState.light_enemies_hit_by_chain_lightning.size() == 0:
			PlayerState.first_enemy_hit_name = name
		PlayerState.light_enemies_hit_by_chain_lightning.append(self)
	else:
		pass
	for index in chain_lightning_shape_cast.get_collision_count():
		if index >= chain_lightning_shape_cast.get_collision_count():
			continue
		var enemy = chain_lightning_shape_cast.get_collider(index)
		
		if enemy != null and not PlayerState.light_enemies_hit_by_chain_lightning.has(enemy.owner):
			enemy = enemy.owner
			if PlayerState.light_enemies_hit_by_chain_lightning.size() <= PlayerState.chain_lightning_max_hits and PlayerState.chain_lightning_ready:
				chain_lightning_animation.animate_chain_lightning($Position.global_position, (enemy as LightEnemy).transformed_position)
				await(get_tree().create_timer(.1).timeout)
				if is_instance_valid(enemy):
					enemy.take_damage(PlayerState.chain_lightning_damage, Vector2.ZERO, 0, false, false)
				pass
			else:
				PlayerState.chain_lightning_current_hits = 0
				PlayerState.clear_enemies_chain_lightning()
		# kiedy nie ma wystarczasjąco przeciwników tez ma działać
		pass
	if PlayerState.first_enemy_hit_name == name:
		PlayerState.clear_enemies_chain_lightning()
	chain_lightning_animation.set_process(false)
	chain_lightning_shape_cast.set_deferred("enabled", false)
