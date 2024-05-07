extends CanvasLayer

signal back_pressed

@export var upgrades : Array[MetaUpgrade] = []

@onready var grid_container = %GridContainer
@onready var back_button = %BackButton

var meta_upgrade_card_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")


func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	back_button.pressed.connect(on_back_pressed)
	for upgrade in upgrades:
		var meta_upgrade_car_instance = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_car_instance)
		meta_upgrade_car_instance.set_meta_upgrade(upgrade)	
		
func on_back_pressed():
	await back_button.finished
	back_pressed.emit()

func change_back_button_text(text:String):
	back_button.text = text
