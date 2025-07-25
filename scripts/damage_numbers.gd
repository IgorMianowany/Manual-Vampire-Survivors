extends Node

func display_number(value : int, position : Vector2, is_critical : bool = false, label : Label = null):
	if value <= 0:
		return
	var number
	if label != null:
		number = label
		number.visible = true
		number.scale = Vector2.ONE
	else:
		number = Label.new()
		
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#fff"
	if is_critical:
		color = "#b22"
	if value == 0:
		color = "fff8"
	number.label_settings.font_color = color
	number.label_settings.font_size = 10
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	if(label == null):
		call_deferred("add_child", number)
		await number.resized
	
	number.pivot_offset = Vector2(number.size / 2)
	 
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	#if label != null:
		#number.visible = false
	#else:
		#number.queue_free()
