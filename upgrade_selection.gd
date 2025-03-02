extends Control

func _ready() -> void:
	var chosen_numbers : Array[int]
	var upgrades : Array[Node] = $CanvasLayer/HBoxContainer.get_children()
	var filtered_upgrades = filter_upgrades(upgrades)
	
	# just for testing
	##TODO remove
	#if PlayerState.upgrades_amount > filtered_upgrades.size():
		#PlayerState.set_upgrades_amount(filtered_upgrades.size()) 
		
	#while chosen_numbers.size() < PlayerState.upgrades_amount:
	while chosen_numbers.size() < filtered_upgrades.size():
		var num = randi_range(0,filtered_upgrades.size()-1)
		if not chosen_numbers.has(num):
			chosen_numbers.append(num)
	#chosen_numbers.remove_at(2)
	#chosen_numbers.append(21)
	for index in filtered_upgrades.size():
		if not chosen_numbers.has(index):
			filtered_upgrades[index].visible = false
	PlayerState.level_up.connect(_upgrade_selection_visible)
	get_tree().paused = true
	for node in filtered_upgrades:
		node.upgrade_selected.connect(_quit)
		
func _input(event):
	# this function is not really working right now because of mouse position shenenigans i'm not
	# yet equiped to deal with at this time, upgrades selected with button
	var mouse_position = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		for node in $"CanvasLayer/HBoxContainer".get_children():
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _quit():
	get_tree().paused = false
	queue_free()

func _upgrade_selection_visible():
	add_child($CanvasLayer)
	
func filter_upgrades(upgrades : Array[Node]) -> Array[Node]:
	var upgrades_filtered = upgrades.duplicate()
	for upgrade in upgrades:
		if not (upgrade as UpgradeSelection).available():
			upgrades_filtered.erase(upgrade)
			# for some reason removed upgrades are still visible, and there is no way to access them
			# after removal so we just hide them here
			upgrade.visible = false
	return upgrades_filtered
