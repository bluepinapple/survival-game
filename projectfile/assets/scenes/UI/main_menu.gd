extends CanvasLayer

@onready var play_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
@onready var options_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var quit_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton
@onready var upgrade_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/UpgradeButton
@onready var health_label = $MarginContainer2/VBoxContainer/HealthLabel
@onready var sword_label = $MarginContainer2/VBoxContainer/SwordLabel

var options_scene = preload("res://scenes/UI/option_menu.tscn")
var upgrade_scene = preload("res://scenes/UI/meta_menu.tscn")

func _ready():
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	upgrade_button.pressed.connect(on_upgrade_button_pressed)

func _process(delta):
	health_label.text = str(10 + MetaProgression.get_upgrade_count("max_health"))
	sword_label.text = str(5 + MetaProgression.get_upgrade_count("sword_meta_damage"))

func on_play_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_button_pressed():
	var option_instance = options_scene.instantiate()
	add_child(option_instance)
	option_instance.back_pressed.connect(on_option_closed.bind(option_instance))


func on_upgrade_button_pressed():
	var upgrade_instance = upgrade_scene.instantiate()
	add_child(upgrade_instance)
	upgrade_instance.back_pressed.connect(on_upgrade_closed.bind(upgrade_instance))

func on_quit_button_pressed():
	get_tree().quit()


func on_option_closed(option_instanced:Node):
	option_instanced.queue_free()


func on_upgrade_closed(upgrade_instance:Node):
	upgrade_instance.queue_free()
