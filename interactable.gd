class_name Interactable
extends Area2D

var interacted : bool = false


func interact():
	#if interacted:
		#return
	#interacted = true
	print("default interact")
