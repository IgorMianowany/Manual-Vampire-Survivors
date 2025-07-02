extends Node2D

@export var texture : Texture2D 

func _ready():
	# Create a canvas item, child of this node.
	var ci_rid = RenderingServer.canvas_item_create()
	# Make this node the parent.
	RenderingServer.canvas_item_set_parent(ci_rid, get_canvas_item())
	# Draw a texture on it.
	# Remember, keep this reference.
	#texture = load("res://my_texture.png")
	# Add it, centered.
	RenderingServer.canvas_item_add_texture_rect(ci_rid, Rect2(-texture.get_size() / 2, texture.get_size()), texture)
	# Add the item, rotated 45 degrees and translated.
	var xform = Transform2D().rotated(deg_to_rad(45)).translated(Vector2(20, 30))
	xform.x = Vector2(376.0,0)
	xform.y = Vector2(0,391.0)
	RenderingServer.canvas_item_set_transform(ci_rid, xform)
