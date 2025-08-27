class_name BossManager
extends Node2D

var boss_scene := preload("res://boss.tscn")


func _ready() -> void:
	PlayerState.zoom_out_camera.emit()
	$Sprite2D.visible = true
	set_as_top_level(true)
	global_position = Vector2(380, 1650)
	await(get_tree().create_timer(2.5).timeout)
	var boss = boss_scene.instantiate()
	add_child(boss)
	boss.global_position = global_position
	await(get_tree().create_timer(.5).timeout)
	$Sprite2D.visible = false
	
func _process(delta: float) -> void:
	$Sprite2D.rotate(.01)
