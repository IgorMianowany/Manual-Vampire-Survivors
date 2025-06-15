class_name Skill
extends Node2D

var cost : float 
var current_cooldown : float
var max_cooldown : float
var skill_scene : PackedScene


func cast_skill():
	var skill = skill_scene.instantiate()
	skill.player = get_tree().get_root().get_child(1)
	print(skill.player.name)
	add_child(skill)
	skill.set_skill_stats()
