extends Node

const SAVE_FILE_PATH = "user://option_data.save"

var option_data : Dictionary = {
	"music":0.1,
	"sfx":1.0,
	"window_mode":1
}

func _ready():
	load_save_file()
	if option_data["window_mode"] == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#add_meta_upgrade(load("res://resources/meta_upgrades/max_health.tres"))


func load_save_file():
	if ! FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH,FileAccess.READ)
	option_data= file.get_var()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"),linear_to_db(option_data["music"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"),linear_to_db(option_data["sfx"]))
	print(option_data["music"])

func save():
	var file = FileAccess.open(SAVE_FILE_PATH,FileAccess.WRITE)
	file.store_var(option_data)


func change_options(option_name : String,option_value : float):
	option_data[option_name] = option_value
	save()


func get_option_value(option_name : String):
	if option_data["option_name"].has(option_name) :
		return option_data["option_name"][option_name]["option_value"]
	return 0
