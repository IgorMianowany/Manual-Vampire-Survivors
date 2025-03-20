class_name PickupsHolder
extends Node2D

func _ready() -> void:
	var experience_pickup := preload("res://experience_pickup.tscn")
	for count in range(0, 100):
		var experience_pickup_instance = experience_pickup.instantiate()
		experience_pickup_instance.experience_points = 1
		self.add_child(experience_pickup_instance)
		PlayerState.experience_pickup_bench.append(experience_pickup_instance)
		experience_pickup_instance.global_position = experience_pickup_instance.get_parent().global_position
