extends Control

@export var upgrades_amount : int = 3
@onready var upgrade_container = $CanvasLayer/HBoxContainer

func _ready() -> void:
	var chosen_numbers : Array[int]
	# just for testing
	##TODO remove
	#if upgrades_amount > upgrade_container.get_children().size():
		#upgrades_amount = upgrade_container.get_children().size()
	var upgrades : Array[Node] = $CanvasLayer/HBoxContainer.get_children()
		
	filter_upgrades(upgrades)
	
	while chosen_numbers.size() < upgrades_amount:
		var num = randi_range(0,upgrades.size()-1)
		if not chosen_numbers.has(num):
			chosen_numbers.append(num)
	for index in upgrades.size():
		if not chosen_numbers.has(index):
			upgrades[index].visible = false
	PlayerState.level_up.connect(_upgrade_selection_visible)
	get_tree().paused = true
	for node in upgrades:
		node.upgrade_selected.connect(_quit)
		
func _input(event):
	# this function is not really working right now because of mouse position shenenigans i'm not
	# yet equiped to deal with at this time, upgrades selected with button
	var mouse_position = get_global_mouse_position()
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		for node in upgrade_container.get_children():
			if node.get_global_rect().has_point(mouse_position):
				node.apply_upgrade()

func _quit():
	get_tree().paused = false
	queue_free()

func _upgrade_selection_visible():
	add_child($CanvasLayer)
	
func filter_upgrades(upgrades : Array[Node]):
	for upgrade in upgrades:
		if not (upgrade as UpgradeSelection).available():
			#this monstrosity is because for some reason just removing the node
			#from array is not enough and it's still being shown on screen,
			#despite not being inside the array, so you cant even click it.
			upgrade.visible = false
			upgrades.remove_at(upgrades.rfind(upgrade))


	
