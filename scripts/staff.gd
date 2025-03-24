class_name Staff
extends WeaponType

var fireball_scene := preload("res://fireball_new.tscn")

var mana_regen_cooldown : float = 2
var mana_regen_timer : Timer

@export var attack_speed := 2.0
@export var mana_cost : float = 1

func _ready() -> void:
	mana_regen_timer = Timer.new()
	add_child(mana_regen_timer)
	mana_regen_timer.timeout.connect(start_mana_regen)
	mana_regen_timer.autostart = false
	mana_regen_timer.one_shot = true


func attack(damage : float, attack_position : Vector2 = Vector2.ZERO, direction : Vector2 = Vector2.ZERO, crit_chance : float = 0, crit_multi : float = 0) -> void:
	if PlayerState.mana >= PlayerState.staff_level_base:
		attack_started.emit()
		mana_regen_timer.start(mana_regen_cooldown)
		PlayerState.mana_regen_blocked = true
		PlayerState.mana -= PlayerState.staff_level_base * 0
		if PlayerState.staff_level_base > 9:
			var meteor := preload("res://meteor_strike.tscn")
			var meteor_instance = meteor.instantiate()
			meteor_instance.global_position = get_global_mouse_position()
			add_child(meteor_instance)
		else:
			for index in projectiles:
				var existing_direction = direction
				# this is done so the arrows are moved based on the center, instead of just 45 degrees down or up
				if projectiles > 1:
					@warning_ignore("integer_division")
					rotation_change = ((-spread/2) + ((spread/(projectiles-1)) * index))
				var angle_in_radians = deg_to_rad(rotation_change)
				var new_direction = existing_direction.rotated(angle_in_radians)

				var projectile = PlayerState.projectile_bench.pop_front()
				projectile.reparent(self)
				projectile.active = true
				projectile.position = attack_position + direction * 15
				projectile.direction = new_direction
				projectile.damage = PlayerState.attack_damage
				projectile.pierce = pierce
				projectile.crit_chance = crit_chance
				projectile.crit_multi = crit_multi
				projectile._reusable_ready()
				#add_child(projectile)
		await(get_tree().create_timer(PlayerState.attack_speed).timeout)
		attack_finished.emit()
		
func temp_meteor_attack():
	pass

func start_mana_regen():
	PlayerState.mana_regen_blocked = false
