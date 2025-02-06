class_name SingleCooldownIndicator
extends Control

@export var current_cooldown : float
@export var max_cooldown : float
@export var texture : CompressedTexture2D

func _ready() -> void:
	$VBoxContainer/MarginContainer/TextureRect.texture = texture
	
func _process(delta: float) -> void:
	var cooldown_visible = current_cooldown > 0
	$VBoxContainer/MarginContainer/Label.visible = cooldown_visible
	$VBoxContainer/MarginContainer/GrayedOut.visible = cooldown_visible
	$VBoxContainer/MarginContainer/Label.text = str(int(current_cooldown) + 1)
	
func player_has_skill() -> bool:
	return true
