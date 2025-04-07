extends Area2D

var speed : float = 100
var land_position_y : float = 0
var land_position_x : float = 0
var start_position_x : float
var travel_distance : float = 300
var reached_x : bool = false
var crit_chance : float = 0.1
var crit_damage : float = 1

func _ready() -> void:
	set_as_top_level(true)
	land_position_y = global_position.y
	land_position_x = global_position.x
	$AnimatedSprite2D.global_position.y -= travel_distance
	$AnimatedSprite2D.global_position.x += randf_range(-150,150)
	start_position_x = $AnimatedSprite2D.global_position.x
	$AnimatedSprite2D.look_at(Vector2(land_position_x, land_position_y))
	$Hitbox.is_player_hitbox = true
	$Hitbox.crit_chance = crit_chance + PlayerState.critical_strike_chance_bonus
	$Hitbox.crit_multi = crit_damage + PlayerState.critical_strike_damage_bonus

func _process(delta: float) -> void:
	if $AnimatedSprite2D.position.y >= -100:
		if not $Hitbox.monitorable:
			$Hitbox.monitorable = true
			$Sprite2D.visible = false
			$AnimatedSprite2D.global_position = global_position
			$AnimatedSprite2D.play("explosion")
			await(get_tree().create_timer(.1).timeout)
			$AnimatedSprite2D.offset = Vector2.ZERO
	else: 
		$AnimatedSprite2D.look_at(Vector2(land_position_x, land_position_y))
		$AnimatedSprite2D.global_position.y += 100 * delta
		if abs(land_position_x - $AnimatedSprite2D.global_position.x) > 1 and not reached_x:
			$AnimatedSprite2D.global_position.x += 1 * sign(land_position_x - $AnimatedSprite2D.global_position.x)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "explosion":
		$Hitbox.set_deferred("monitorable", false)
		queue_free()
