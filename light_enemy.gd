class_name LightEnemy
extends Node2D

var object 
var img
var speed : float = 50
@export var player : Player
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
@onready var damage_numbers_origin = $Position/DamageNumbersOrigin
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
var velocity : Vector2


@onready var box_shape = CircleShape2D.new()
@export var tex : Texture2D

var hp : float = 100

func _ready() -> void:
	box_shape.radius = 8
	var ps = PhysicsServer2D
	object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, box_shape)
	ps.body_add_collision_exception(object, player)
	ps.body_set_param(object, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0)
	
	
	#var transform = Transform2D(0, Vector2(250, 250))
	var transform = Transform2D(0, Vector2.ZERO)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, transform)
	
	#var rs = RenderingServer
	#img = rs.canvas_item_create()
	#rs.canvas_item_set_parent(img, get_canvas_item())
	##rs.canvas_item_add_texture_rect(img, Rect2(Vector2(409, -516),Vector2(32,32)), tex)
	#rs.canvas_item_add_texture_rect(img, Rect2(Vector2(-16, -16),Vector2(32,32)), tex)
	#rs.canvas_item_set_transform(img, transform)
	
func _process(delta: float) -> void:
	jump_timer += delta
	print(jump_timer)
	print(jump_cooldown + jump_duration + variation)


func _physics_process(delta: float) -> void:
	jump_toward_player(variation)
	if hp < 0:
		queue_free()
	var trans = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
	#velocity = trans.origin.direction_to(player.position) * 50 * delta
	var next_position : Vector2 = trans.origin + velocity * delta
	trans = Transform2D(0, next_position)
	$Position.global_position = trans.origin
	#RenderingServer.canvas_item_set_transform(img, trans)
	PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)
	
	
func _exit_tree() -> void:
	PhysicsServer2D.free_rid(object)
	#RenderingServer.free_rid(img)
	
func set_enemy_position(pos : Vector2):
	var trans = Transform2D(0, pos)

	#RenderingServer.canvas_item_set_transform(img, trans)
	PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)

func take_damage(damage : float, direction : Vector2, knockback_power : float, is_poison : bool, is_crit : bool):
	hp -= damage * 15
	print(hp)
	
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
			$Position/AnimatedSprite2D.play("move_down")
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
	_on_animation_finished($Position/AnimatedSprite2D.animation)
	is_jumping = false
	$Position/AnimatedSprite2D.play("idle_down")
	
	
func _on_animation_finished(anim_name : StringName):
	if anim_name == "die":
		if PlayerState.experience_pickup_bench.size() != 0:
			var experience_pickup_new = PlayerState.experience_pickup_bench.pop_front()
			experience_pickup_new.reset(global_position)
		$Position/Control.global_position = global_position
		#experience_pickup_new.turn_on_collision()
		#experience_pickup_new.global_position = global_position
		#experience_pickup_new.player = null
		#experience_pickup_new.active = true
		#experience_pickup_new.speed = 10000
		#PlayerState.active_enemies_count -= 2
		PlayerState.coins_base += money
	is_jumping = false
	$Position/AnimatedSprite2D.play("idle_down")
