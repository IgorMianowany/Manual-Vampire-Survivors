extends Node2D

var objects = []

@onready var box_shape = CircleShape2D.new()
@export var tex : Texture2D
var count  = 2400
func _ready() -> void:
	for i in range(count):
		create_objects(Vector2(randf_range(0, 1600), randf_range(10, -10)))
		
func create_objects(pos : Vector2):
	box_shape.radius = 4
	var ps = PhysicsServer2D
	var object = ps.body_create()
	ps.body_set_space(object, get_world_2d().space)
	ps.body_add_shape(object, box_shape)
	ps.body_set_param(object, PhysicsServer2D.BODY_PARAM_FRICTION, 0.1)

	
	var transform = Transform2D(0, pos)
	ps.body_set_state(object, ps.BODY_STATE_TRANSFORM, transform)
	
	var rs = RenderingServer
	var img = rs.canvas_item_create()
	rs.canvas_item_set_parent(img, get_canvas_item())
	rs.canvas_item_add_texture_rect(img, Rect2(-4,-4,8,8), tex)
	rs.canvas_item_set_transform(img, transform)
	
	objects.append([object, img])
	
func _physics_process(delta: float) -> void:
	$CanvasLayer/Label.text =  str(Engine.get_frames_per_second())
	for obj in objects:
		var trans = PhysicsServer2D.body_get_state(obj[0], PhysicsServer2D.BODY_STATE_TRANSFORM)
		RenderingServer.canvas_item_set_transform(obj[1], trans)
