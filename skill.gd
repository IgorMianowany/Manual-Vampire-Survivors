class_name Skill
extends Node2D

var cost : float 
var current_cooldown : float
var max_cooldown : float
var skill_scene : PackedScene
var skill : CommonSkill

func cast_skill():
	var _skill = skill_scene.instantiate()
	skill = _skill
	_skill.player_position = global_position
	add_child(_skill)
	_skill.set_skill_stats()
