class_name SkillSlot
extends Control

var available : bool
var cost : int
var skill : CommonSkill
var icon : Texture2D


func _process(delta: float) -> void:
	if not available:
		$ColorRect/MarginContainer.z_index = -1
	else:
		$ColorRect/MarginContainer.z_index = 0
	
	available = cost <= PlayerState.get_current_resource() and skill.cooldown <= 0
	
func set_skill_info(_skill: CommonSkill):
	skill = _skill
	cost = _skill.cost
	icon = _skill.icon
	$ColorRect/Label.text = str(cost)
	$ColorRect/MarginContainer/TextureRect.texture = icon
		
