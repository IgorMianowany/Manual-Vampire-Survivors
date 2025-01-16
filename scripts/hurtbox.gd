class_name Hurtbox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 16


func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	
func _on_area_entered(hitbox : Hitbox) -> void:
	#print(hitbox.owner.name)
	if hitbox == null or hitbox.owner == owner:
		return
		
	if owner.name != "Player" and hitbox.owner.name != "Player":
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power)
		#if owner is Slime:
			#hitbox.list_of_enemies.append(owner)
