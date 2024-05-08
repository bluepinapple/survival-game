extends Node

const DIFFICULTY_INTERVAL = 5

signal arena_difficulty_increased(arena_difficulty : int)

@onready var timer = $Timer

@export var end_scene : PackedScene

var arena_difficulty = 0


func _ready():
	timer.set_wait_time(timer.get_wait_time() + MetaProgression.get_upgrade_count("game_time")*60.0) 
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	

func _process(delta):
	var next_target_time = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	if timer.time_left <= next_target_time:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_scene_instance = end_scene.instantiate()
	add_child(end_scene_instance)
	MusicPlayer.stop()
	MetaProgression.save()
	end_scene_instance.play_jingles()
