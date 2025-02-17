extends Control
var timer : float
var upgrade_selection := preload("res://upgrade_selection.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.level_up.connect(_on_level_up)
	PlayerState.after_level_up.connect(_after_level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	$CanvasLayer/Healthbar.value = PlayerState.health
	$CanvasLayer/ExperienceBar.value = PlayerState.experience
	$CanvasLayer/HealthForDebug.text = str(PlayerState.health) + "/" + str(PlayerState.max_health)
	$CanvasLayer/FPS.text = "FPS: %s" % [Engine.get_frames_per_second()]
	$CanvasLayer/Manabar.visible = PlayerState.chosen_class == 2
	$CanvasLayer/Manabar.value = PlayerState.mana
	$CanvasLayer/Manabar.max_value = PlayerState.max_mana
	$CanvasLayer/HasChainLightning.text = str(PlayerState.slime_count)
	$CanvasLayer/Level.text = str(PlayerState.slime_count)


func _on_level_up() -> void:
	add_child(upgrade_selection.instantiate())
	
func _after_level_up():
	$CanvasLayer/Healthbar.max_value = PlayerState.max_health
	$CanvasLayer/Healthbar.value = PlayerState.health
	$CanvasLayer/ExperienceBar.value = PlayerState.experience
	$CanvasLayer/ExperienceBar.max_value = PlayerState.experience_threshold
	$CanvasLayer/Level.text = str(PlayerState.level)
	
func toggle_stat_sheet():
	$CanvasLayer/StatSheet.toggle_stat_sheet()
	
