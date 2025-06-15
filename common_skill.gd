class_name CommonSkill
extends Node2D

var player_position : Vector2
var cooldown : float
var cost : float
var icon : Texture2D = preload("res://icon.svg")



func _process(delta: float) -> void:
	cooldown -= delta
	
