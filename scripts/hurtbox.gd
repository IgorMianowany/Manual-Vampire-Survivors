class_name Hurtbox
extends Area2D

#signal take_damage

func _init() -> void:
	collision_layer = 0
	collision_mask = 16


func _ready() -> void:
	connect("area_entered", self._on_area_entered)
	
func _on_area_entered(hitbox : Hitbox) -> void:
	if hitbox == null or hitbox.owner == owner:
		return
	
	if owner.name == hitbox.owner.get_parent().get_parent().get_parent().name:
		return
		
	if owner.name.contains("Slime") and hitbox.owner.name.contains("Slime"):
		return
	print(PlayerState.has_poison_attacks)
	if owner.has_method("take_damage"):
		if hitbox.owner.name == "Player":
			owner.take_damage(hitbox.damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks)
		elif hitbox.owner.get_parent().get_parent().get_parent().name == "Player":
			if hitbox.hits < hitbox.max_hits:
					hitbox.hits += 1
					owner.take_damage(hitbox.damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks)
		elif owner.name == "Player" or hitbox.get_parent().get_parent().get_parent().name == "Player":
					owner.take_damage(hitbox.damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks)
