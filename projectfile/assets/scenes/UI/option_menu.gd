extends CanvasLayer

signal back_pressed

@onready var window_button : Button = $%WindowButton
@onready var sfx_slider = %SfxSlider
@onready var music_slider = %MusicSlider
@onready var back_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
@onready var quit_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton


func _ready():
	sfx_slider.value_changed.connect(on_audio_slider_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_changed.bind("music"))
	window_button.pressed.connect(on_window_button_pressed)
	back_button.pressed.connect(on_back_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	update_display()


func update_display():
	window_button.text = "窗口模式"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "全屏模式"
	OptionSave.load_save_file()
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


func get_bus_volume_percent(bus_name : String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)
	

func set_bus_volume_percent(bus_name : String , percent : float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index,volume_db)
	OptionSave.change_options(bus_name,percent)
	

func on_audio_slider_changed(value:float,bus_name : String):
	set_bus_volume_percent(bus_name,value)

	
func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		OptionSave.change_options("window_mode",0)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		OptionSave.change_options("window_mode",1)
	update_display()

func on_back_pressed():
	await back_button.finished
	back_pressed.emit()
	

func on_quit_pressed():
	get_tree().quit()
