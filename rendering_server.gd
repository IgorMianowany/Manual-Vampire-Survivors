extends Node2D

@export var texture : Texture2D 
var body
var shape

func _body_moved(state, index):
	# Create a canvas item, child of this node.
	var ci_rid = RenderingServer.canvas_item_create()
	# Make this node the parent.
	RenderingServer.canvas_item_set_parent(ci_rid, get_canvas_item())
	# Draw a texture on it.
	# Remember, keep this reference.
	# Add it, centered.
	RenderingServer.canvas_item_add_texture_rect(ci_rid, Rect2(-texture.get_size() / 2, texture.get_size()), texture)
	# Created your own canvas item, use it here.
	RenderingServer.canvas_item_set_transform(ci_rid, state.transform)


func _ready():
	# Create the body.
	body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_RIGID)
	# Add a shape.
	shape = PhysicsServer2D.rectangle_shape_create()
	# Set rectangle extents.
	PhysicsServer2D.shape_set_data(shape, Vector2(10, 10))
	# Make sure to keep the shape reference!
	PhysicsServer2D.body_add_shape(body, shape)
	# Set space, so it collides in the same space as current scene.
	PhysicsServer2D.body_set_space(body, get_world_2d().space)
	# Move initial position.
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0, Vector2(10, 20)))
	# Add the transform callback, when body moves
	# The last parameter is optional, can be used as index
	# if you have many bodies and a single callback.
	#PhysicsServer2D.body_set_force_integration_callback(body, _body_moved, self)
