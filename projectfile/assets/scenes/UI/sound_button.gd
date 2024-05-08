extends Button

signal finished

@onready var random_audio_stream_player_component = $RandomAudioStreamPlayerComponent

func _ready():
	random_audio_stream_player_component.finished.connect(on_strean_finished)
	pressed.connect(on_pressed)
	

func on_pressed():
	random_audio_stream_player_component.play_random()
	#await random_audio_stream_player_component.finished


func on_strean_finished():
	finished.emit()
