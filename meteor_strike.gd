extends Area2D

var speed : float = 100
var land_position_y : float = 0

func _ready() -> void:
	land_position_y = global_position.y
	$AnimatedSprite2D.global_position.y = $AnimatedSprite2D.global_position.y - 100

func _process(delta: float) -> void:
	if $AnimatedSprite2D.global_position.y >= land_position_y:
		return
	$AnimatedSprite2D.global_position.y = $AnimatedSprite2D.global_position.y + 100 * delta
