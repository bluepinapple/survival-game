extends Node

const SPWAN_RADIUS = 360

@export var basic_enemy_scenes : PackedScene
@export var wizard_enemy_scene : PackedScene
@export var mouse_enemy_scene : PackedScene
@export var ghost_enemy_scene : PackedScene
@export var treasure_chest_enemy : PackedScene
@export var meta_wizard_enemy_scene : PackedScene

@export var arena_timer_manager : Node

@onready var timer = $Timer

var basic_spwan_time = 0
var enemy_table = weightedTable.new()
var is_add_mouse : bool
var is_add_wizard : bool
var is_add_ghost : bool
var is_add_chest : bool
var is_add_meta_wizard : bool


func _ready():
	is_add_wizard = false
	is_add_mouse = false
	is_add_ghost = false
	is_add_chest = false
	is_add_meta_wizard = false
	
	enemy_table.add_items(basic_enemy_scenes,30)
	basic_spwan_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_timer_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func get_spwan_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spwan_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	for i in 4:
		spwan_position = player.global_position + (random_direction * SPWAN_RADIUS)
		var additonal_check_offset = random_direction * 20
	
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position,(spwan_position+additonal_check_offset),1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spwan_position

func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var enemy = enemy_scene.instantiate() as Node2D
	#print("11111")
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = get_spwan_position()


func on_arena_difficulty_increased(arena_difficulty:int):
	var time_off =(.1/4) * arena_difficulty
	time_off = min(time_off,.38)
	#print(time_off)
	timer.wait_time = basic_spwan_time - time_off
	
	if !is_add_mouse:
		if arena_difficulty == 6:
			enemy_table.add_items(mouse_enemy_scene,5)
			is_add_mouse = true
	
	if is_add_wizard == false:
		if arena_difficulty == 10:
			enemy_table.add_items(wizard_enemy_scene,10)
			is_add_wizard = true
	
	if is_add_ghost == false:
		if arena_difficulty == 22:
			enemy_table.add_items(ghost_enemy_scene,15)
			is_add_ghost = true
	
	if is_add_chest == false:
		if arena_difficulty == 16:
			enemy_table.add_items(treasure_chest_enemy,1)
			is_add_chest = true
	
	if is_add_meta_wizard == false:
		if arena_difficulty == 30:
			enemy_table.add_items(meta_wizard_enemy_scene,2)
			is_add_chest = true
	
