class_name LightEnemy
extends Node2D

var object 
var img

@onready var box_shape = RectangleShape2D.new()
@export var tex : Texture2D

func _ready() -> void:
	box_shape.size = Vector2(25, 25)
	var ps = PhysicsServer2D
	object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, box_shape)
	
	var transform = Transform2D(0, Vector2(250, 250))
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, transform)
	
	var rs = RenderingServer
	img = rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	rs.canvas_item_add_texture_rect(img, Rect2(-12.5,-12.5,25,25), tex)
	rs.canvas_item_set_transform(img, transform)
	
func _physics_process(delta: float) -> void:
	var trans = PhysicsServer2D.body_get_state(object, PhysicsServer2D.BODY_STATE_TRANSFORM)
	RenderingServer.canvas_item_set_transform(img, trans)
	
	
func _exit_tree() -> void:
	PhysicsServer2D.free_rid(object)
	RenderingServer.free_rid(img)
