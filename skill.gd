class_name Skill
extends Node2D

var cost : float 
var current_cooldown : float
var max_cooldown : float
var skill_scene : PackedScene


func cast_skill():
	var skill = skill_scene.instantiate()
	skill.player_position = global_position
	add_child(skill)
	skill.set_skill_stats()
