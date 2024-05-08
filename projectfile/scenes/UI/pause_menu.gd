extends CanvasLayer

@onready var panel_container = $MarginContainer/PanelContainer
@onready var resume_button = %ResumeButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton

var options_scene = preload("res://scenes/UI/option_menu.tscn")
var is_closing : bool = false


func _ready():
	get_tree().paused = true
	
	resume_button.pressed.connect(on_resume_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	$AnimationPlayer.play("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.tween_property(panel_container,"scale",Vector2.ONE,.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		closed()
		get_tree().root.set_input_as_handled()
		

func closed():
	if is_closing:
		return
	is_closing = true
	$AnimationPlayer.play_backwards("default")
	
	var tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ONE,0)
	tween.tween_property(panel_container,"scale",Vector2.ZERO,.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	
	queue_free()


func on_resume_button_pressed():
	closed()
	
	
func on_options_button_pressed():
	var option_instance = options_scene.instantiate()
	add_child(option_instance)
	option_instance.back_pressed.connect(on_option_closed.bind(option_instance))


func on_quit_button_pressed():
	get_tree().quit()
	

func on_option_closed(option_instanced:Node):
	option_instanced.queue_free()
