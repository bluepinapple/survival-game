extends Node

const MAX_RANGE = 150

@export var sword_ability : PackedScene
@onready var timer = $Timer

var basic_damage = 5
var additional_damage_percent = 1
var basic_wait_time
var enemies : Array
var amount : int = 1
var player : CharacterBody2D
var scale = 1
var is_started = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_basic_damage()
	basic_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func set_basic_damage():
	if is_started:
		basic_damage = basic_damage + MetaProgression.get_upgrade_count("sword_meta_damage")
		is_started = false	
	else :
		return
	
	
func spwan_sword(amount_sword:int,scale_amount = 1):
	if enemies.size()<amount_sword:
		amount_sword = enemies.size()
	for i in amount_sword:
		if enemies[i] == null:
			return
		var sword_instance = sword_ability.instantiate() as Node2D
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(sword_instance)
		sword_instance.hitbox_component.damage = basic_damage * additional_damage_percent
		sword_instance.global_position = enemies[i].global_position
		#sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU))*4
		sword_instance.scale =sword_instance.scale * Vector2(scale_amount,scale_amount)
		var enemy_direction =  player.global_position - enemies[i].global_position
		sword_instance.rotation = enemy_direction.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_timer_timeout():
	#print("111")
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player.global_position)< pow(MAX_RANGE,2)
		)
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	spwan_sword(amount,scale)
	
	

func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduce = current_upgrades["sword_rate"]["quantity"]*.2
		timer.wait_time = basic_wait_time * max((1-percent_reduce),0.1)
		timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent =( basic_damage+(current_upgrades["sword_damage"]["quantity"] * 3.0)) / basic_damage
	
	elif upgrade.id == "sword_amount":
		amount += 1
	
	elif upgrade.id == "sword_scale_up":
		scale += .2
		
