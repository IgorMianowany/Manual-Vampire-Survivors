extends Control
var timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.level_up.connect(_on_level_up)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Healthbar.value = PlayerState.health
	$CanvasLayer/Healthbar.max_value = PlayerState.max_health
	$CanvasLayer/HealthForDebug.text = str(PlayerState.health)
	$CanvasLayer/ExperienceBar.value = PlayerState.experience
	$CanvasLayer/ExperienceBar.max_value = PlayerState.experience_threshold
	$CanvasLayer/Level.text = str(PlayerState.level)

func _on_level_up() -> void:
	$CanvasLayer/ExperienceBar.value = PlayerState.experience
	$CanvasLayer/ExperienceBar.max_value = PlayerState.experience_threshold
	$CanvasLayer/Level.text = str(PlayerState.level)
	
