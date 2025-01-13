extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Healthbar.value = PlayerState.health
	$CanvasLayer/Healthbar.max_value = PlayerState.max_health
	$CanvasLayer/HealthForDebug.text = str(PlayerState.health)
