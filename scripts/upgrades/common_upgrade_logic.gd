class_name CommonUpgradeLogic
extends UpgradeSelection


func _ready() -> void:
	upgrade = PlayerState.UPGRADES.MISC
	upgrade_name = add_spaces_to_camel_case(name)
	super()
	
func apply_upgrade():
	add_item_effect()
	super()

func add_item_effect():
	print("default item effect")
	
func add_spaces_to_camel_case(input_string: String) -> String:
	var result = ""
	
	# Iterate through each character in the string
	for i in range(input_string.length()):
		var current_char = input_string[i]
		
		# If the current character is uppercase and it's not the first character,
		# add a space before it
		if i > 0 and current_char == current_char.to_upper():
			result += " "
		
		# Append the current character to the result
		result += current_char
	
	return result

func available() -> bool:
	return true
