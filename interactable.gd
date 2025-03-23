class_name Interactable
extends Area2D

func interact():
	monitorable = false
	
func toggle_interact_outline(_value : bool):
	($Sprite2D.material as ShaderMaterial).set_shader_parameter("width", int(_value))
