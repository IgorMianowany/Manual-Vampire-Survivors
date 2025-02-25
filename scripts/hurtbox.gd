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
	
	if owner.name == hitbox.owner.get_parent().get_parent().get_parent().name:
		return
		
	if owner.name.contains("Slime") and hitbox.owner.name.contains("Slime"):
		return
		
	if name.contains("Slime") and hitbox.name.contains("Slime"):
		return
	
	if owner.name == "Player" and hitbox.owner.name.contains("Summon"):
		return
		
	# remember that taking damage from fireball logic is in fireball_new script for some reason
	# TODO this is shit, rewrite 
	if owner.has_method("take_damage"):
		var is_crit = hitbox.is_crit()
		var damage = hitbox.damage + hitbox.damage * (hitbox.crit_multi + PlayerState.critical_strike_damage_bonus) * int(is_crit)
		if hitbox.owner.name == "Player":
			owner.take_damage(damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks, is_crit)
		elif hitbox.owner.get_parent().get_parent().get_parent().name == "Player":
			if hitbox.hits < hitbox.max_hits:
				hitbox.hits += 1
				if hitbox.hitbox_name == "ShurikenHitbox":
					hitbox.owner.life -= 1
					hitbox.hits -= 1
					hitbox.owner.hit.emit()
				owner.take_damage(damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks, is_crit)
		elif owner.name == "Player" or hitbox.get_parent().get_parent().get_parent().name == "Player":
			owner.take_damage(damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks, is_crit)

		else:
			owner.take_damage(damage, hitbox.owner.global_position.direction_to(owner.global_position), hitbox.knockback_power, PlayerState.has_poison_attacks, is_crit)
			if hitbox.owner.name == "KnifeSummon":
				(hitbox.owner as KnifeSummon).reached_target.emit()
