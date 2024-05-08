extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent

var basic_rotation = Vector2.RIGHT
var duration : float = 3

func _ready():
	basic_rotation = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	var tween = create_tween()
	tween.tween_method(tween_method,0.0,2.0*(duration/3.0),duration)
	
	tween.tween_callback(queue_free)
	

func tween_method(axe_rotation:float):
	var percent = axe_rotation/2
	var current_radius = percent * MAX_RADIUS
	var current_direction = basic_rotation.rotated(axe_rotation * TAU)
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = player.global_position + (current_direction * current_radius)
	
