class_name Hurtbox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 16


func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	
func _on_area_entered(hitbox : Hitbox) -> void:
	if hitbox == null or hitbox.owner == owner:
		return
		
	if not owner.name == "Player" and hitbox.owner.name != "Player":
		return
		#
	 #or hitbox.owner.name != "Player":
		#return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, hitbox.global_position.direction_to(owner.global_position), hitbox.knockback_power)
