class_name LightEnemy
extends Node2D

var object 
var img
var speed : float = 50
@export var player : Player

@onready var box_shape = RectangleShape2D.new()
@export var tex : Texture2D

var hp : float = 100

func _ready() -> void:
	box_shape.size = Vector2(32, 32)
	var ps = PhysicsServer2D
	object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, box_shape)
	ps.body_add_collision_exception(object, player)
	ps.body_set_param(object, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0)
	
	
	#var transform = Transform2D(0, Vector2(250, 250))
	var transform = Transform2D(0, Vector2.ZERO)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, transform)
	
	var rs = RenderingServer
	img = rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	#rs.canvas_item_add_texture_rect(img, Rect2(Vector2(409, -516),Vector2(32,32)), tex)
	rs.canvas_item_add_texture_rect(img, Rect2(Vector2(-16, -16),Vector2(32,32)), tex)
	rs.canvas_item_set_transform(img, transform)
	
	
func _physics_process(delta: float) -> void:
	if hp < 0:
		queue_free()
	var trans = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
	var velocity = trans.origin.direction_to(player.position) * 50 * delta
	var next_position : Vector2 = trans.origin + velocity
	trans = Transform2D(0, next_position)
	$Position.global_position = trans.origin
	RenderingServer.canvas_item_set_transform(img, trans)
	PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)
	
	
func _exit_tree() -> void:
	PhysicsServer2D.free_rid(object)
	RenderingServer.free_rid(img)
	
func set_enemy_position(pos : Vector2):
	var trans = Transform2D(0, pos)

	RenderingServer.canvas_item_set_transform(img, trans)
	PhysicsServer2D.body_set_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM, trans)

func take_damage(damage : float, direction : Vector2, knockback_power : float, is_poison : bool, is_crit : bool):
	hp -= damage * 15
	print(hp)
	

			
