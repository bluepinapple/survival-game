extends CanvasLayer

signal upgrade_selected(upgrade : AbilityUpgrade)

@export var upgrade_card_scene : PackedScene

@onready var car_container : HBoxContainer = $%CardContainer


func _ready():
	get_tree().paused = true

func set_ability_upgrade(upgrades:Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var car_instance = upgrade_card_scene.instantiate()
		car_container.add_child(car_instance)
		car_instance.set_ability_upgrade(upgrade)
		car_instance.play_in(delay)
		car_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.2

func on_upgrade_selected(upgrade:AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
	
