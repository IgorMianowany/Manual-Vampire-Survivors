class_name SkillSlot
extends Control

var available : bool
var cost : float
var skill : CommonSkill
var icon : Texture2D


func _process(_delta: float) -> void:
	if not available:
		$ColorRect/MarginContainer.z_index = -1
	else:
		$ColorRect/MarginContainer.z_index = 0
	if skill != null:
		available = cost <= PlayerState.get_current_resource() and skill.cooldown <= 0
	else:
		available = false
	
func set_skill_info(_skill: CommonSkill):
	skill = _skill
	cost = _skill.cost
	icon = _skill.icon
	$ColorRect/Label.text = str(cost)
	$ColorRect/MarginContainer/TextureRect.texture = icon
		
