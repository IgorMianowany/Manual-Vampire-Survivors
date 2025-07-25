extends ProgressBar


@onready var timer = $Timer
@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health
var subtract_damage : bool = false

func _process(_delta: float) -> void:
	if subtract_damage and damage_bar.value > health:
		for index in range(30):
			damage_bar.value -= .1
	

func _set_health(new_health : float):
	var prev_health = health
	if prev_health == 0:
		prev_health = max_value
	health = min(max_value, new_health)
	#value = health
	set_value_no_signal(health)
	
	if health < prev_health:
		timer.start()
		subtract_damage = false
	else:
		damage_bar.value = health

func init_health(_health):
	health = _health
	
	max_value = _health
	value = _health
	damage_bar.max_value = _health
	damage_bar.value = _health



func _on_timer_timeout() -> void:
	subtract_damage = true
