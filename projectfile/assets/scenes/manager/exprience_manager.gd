extends Node

const TARGET_EXPRIENCE_GROWTH = 5

signal exprience_update(current_exprience:float,target_exprience:float)
signal level_up(new_level:int)

@export var upgrade_particle : PackedScene
@onready var plz_press_e = $CanvasLayer/MarginContainer/PlzPressE
@onready var margin_container = $CanvasLayer/MarginContainer

var current_exprience = 0
var target_exprience = 8
var current_level = 1
var is_waiting_upgrade : bool = false
var player : Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	plz_press_e.visible = false
	GameEvents.exprience_vial_collected.connect(on_exprience_vial_collected)

func _physics_process(delta):
	if	Input.is_action_pressed("upgrade") && is_waiting_upgrade:
		upgrade_level_up()
	
func increment_exprience(number:float):
	current_exprience = current_exprience + number + MetaProgression.get_upgrade_count("start_exprience")
	current_exprience = min(current_exprience,target_exprience)
	exprience_update.emit(current_exprience,target_exprience)
	if current_exprience == target_exprience:
		if MetaProgression.save_data["meta_upgrade_currency"] < 500 :
			plz_press_e.visible = true
		is_waiting_upgrade = true
		print(MetaProgression.save_data["meta_upgrade_currency"])
		
		var upgrade_particle_instance = upgrade_particle.instantiate()
		
		var particles = get_tree().get_nodes_in_group("upgrade_particle")
		if particles.size() <= 0:
			player.add_child(upgrade_particle_instance)
		
	#print(current_exprience)	

func upgrade_level_up():
	plz_press_e.visible = false
	var particles = get_tree().get_nodes_in_group("upgrade_particle")
	for partcle in particles:
		partcle.queue_free()
	current_level += 1
	target_exprience += TARGET_EXPRIENCE_GROWTH
	current_exprience = 0
	exprience_update.emit(current_exprience,target_exprience)
	level_up.emit(current_level)
	is_waiting_upgrade = false


func on_exprience_vial_collected(number:float):
	increment_exprience(number)
