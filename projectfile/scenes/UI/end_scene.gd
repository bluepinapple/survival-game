extends CanvasLayer

@onready var panel_container = $MarginContainer/PanelContainer
@onready var continue_button = %ContinueButton
@onready var quit_button = %QuitButton

var meta_upgrade_scene = preload("res://scenes/UI/meta_menu.tscn")

func _ready():
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.tween_property(panel_container,"scale",Vector2.ONE,1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quitbutton_pressed)
	

func set_defeat():
	$%TitleLabel.text = "死亡"
	$%DescriptionLabel.text = "这样的世界，到底谁能活啊？！"
	MusicPlayer.stop()
	play_jingles(true)
	

func play_jingles(defeat : bool = false):
	if defeat :
		$DefeatStreamPlayerComponent.play_random()
	else :
		$VictoryStreamPlayerComponent.play_random()
	
	
func on_continue_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	var upgrade_instance = meta_upgrade_scene.instantiate()
	add_child(upgrade_instance)
	upgrade_instance.change_back_button_text("继续！")
	upgrade_instance.back_pressed.connect(on_back_pressed.bind(upgrade_instance))


func on_back_pressed(upgrade_instance : Node):
	get_tree().paused = false
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	upgrade_instance.queue_free()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	MusicPlayer.play()
	
func on_quitbutton_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
