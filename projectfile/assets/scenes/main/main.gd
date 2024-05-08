extends Node

@export var end_scene : PackedScene

var pause_scene = preload("res://scenes/UI/pause_menu.tscn")


func _ready():
	$%player.health_component.died.connect(on_player_died)
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(pause_scene.instantiate())
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_scene_instance = end_scene.instantiate()
	add_child(end_scene_instance)
	end_scene_instance.set_defeat()
