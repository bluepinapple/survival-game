extends Node


@export var axe_ability : PackedScene

@onready var timer = $Timer

var basic_damage = 10
var additional_damage_percent = 1
var basic_wait_time
var scale = 1
var duration_time = 3

func _ready():
	basic_damage = basic_damage + MetaProgression.get_upgrade_count("axe_meta_damage")
	basic_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	

func spwan_axe(scale_amont,duration):
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var fore_ground = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if fore_ground == null:
		return
	
	var axe_instance = axe_ability.instantiate() as Node2D
	axe_instance.duration = duration
	fore_ground.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.scale = axe_instance.scale * Vector2(scale_amont,scale_amont)
	axe_instance.hitbox_component.damage = basic_damage * additional_damage_percent


func on_timer_timeout():
	spwan_axe(scale,duration_time)


func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id == "axe_damage":
		additional_damage_percent = (basic_damage + current_upgrades["axe_damage"]["quantity"] * 5.0)/ basic_damage
	
	elif upgrade.id == "axe_rate":
		var percent_reduce = current_upgrades["axe_rate"]["quantity"]*.1
		timer.wait_time = basic_wait_time * max((1-percent_reduce),0.2)
		timer.start()
		
	elif upgrade.id == "axe_scale_up":
		scale += .2
	
	elif upgrade.id == "axe_being_time_up":
		duration_time += 1
