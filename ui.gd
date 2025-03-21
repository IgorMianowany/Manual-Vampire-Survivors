extends Control
var timer : float
var upgrade_selection := preload("res://upgrade_selection.tscn")
var main_menu := preload("res://start_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.level_up.connect(_on_level_up)
	PlayerState.after_level_up.connect(_after_level_up)
	PlayerState.player_death.connect(_on_player_death)
	$CanvasLayer/Healthbar.max_value = PlayerState.max_health
	$CanvasLayer/OnDeathControls.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	$CanvasLayer/Timer.text = str(int(PlayerState.game_time))
	$CanvasLayer/Healthbar.value = PlayerState.health
	$CanvasLayer/ExperienceBar.value = PlayerState.experience
	$CanvasLayer/ExperienceBar.max_value = PlayerState.experience_threshold
	$CanvasLayer/HealthForDebug.text = str(PlayerState.health) + "/" + str(PlayerState.max_health)
	$CanvasLayer/FPS.text = "FPS: %s" % [Engine.get_frames_per_second()]
	$CanvasLayer/Manabar.visible = PlayerState.chosen_class == 2
	$CanvasLayer/Manabar.value = PlayerState.mana
	$CanvasLayer/Manabar.max_value = PlayerState.max_mana
	$CanvasLayer/HasChainLightning.text = str(PlayerState.active_enemies_count)
	$CanvasLayer/Level.text = str(PlayerState.active_enemies_count)


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
	
func _on_player_death():
	$CanvasLayer/OnDeathControls/VBoxContainer/MarginContainer/FinalScoreText.text += str(PlayerState.final_score)
	$CanvasLayer/OnDeathControls.visible = true
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")
	
func toggle_interact_visibility(_visible : bool):
	$CanvasLayer/Interact.visible = _visible
