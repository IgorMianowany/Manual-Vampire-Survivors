class_name BossProjectile
extends Node2D

var speed : float = 50
var direction : Vector2
var body : RID
var img : RID
var start_pos : Vector2
var texture : Texture2D = preload("res://assets/sprites/projectiles/black_hole.png")
var rs = RenderingServer
var current_transform : Transform2D
var lifetime : float = 3

func _ready() -> void:
	set_as_top_level(true)
	var ps = PhysicsServer2D
	body = ps.body_create()
	ps.body_set_space(body, get_world_2d().space)
	ps.body_add_shape(body, $Position/Hitbox/CollisionShape2D.shape)
	ps.body_set_param(body, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0)
	ps.body_set_collision_layer(body, 6)
		
	#var transform = Transform2D(0, Vector2(250, 250))
	var trans = Transform2D(0, start_pos)
	ps.body_set_state(body, ps.BODY_STATE_TRANSFORM, trans)
	
	current_transform = trans
	img = rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	rs.canvas_item_add_texture_rect(img, Rect2(Vector2(-8, -8),Vector2(16,16)), texture)
	rs.canvas_item_set_transform(img, current_transform)

func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime < 0:
		queue_free()
	#current_transform = current_transform.rotated(deg_to_rad(2))
	RenderingServer.canvas_item_set_transform(img, current_transform)

func _physics_process(delta: float) -> void:
	current_transform.origin += direction * speed * delta
	#current_transform = current_transform.translated(direction * speed * delta)
	current_transform = Transform2D(0, current_transform.origin)
	$Position.global_position = current_transform.origin
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, current_transform)
