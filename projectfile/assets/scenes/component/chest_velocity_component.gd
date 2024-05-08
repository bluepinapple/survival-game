extends Node

signal arrived

@export var max_speed :int
@export var acceleration : float

@onready var animation_player = $"../AnimationPlayer"
@onready var sprite_2d = $"../Visuals/Sprite2D"
@onready var collision_shape_2d = $"../PickupArea2D/CollisionShape2D"
@onready var owner_node2d = $".."
@onready var gpu_particles_2d = $"../GPUParticles2D"
@onready var timer = $"../Timer"

var velocity = Vector2.ZERO
var target_position : Vector2

var is_playing_inhale : bool = false
var should_walk : bool = true

func _ready():
	arrived.connect(on_arrived)


func check_particles():
	if gpu_particles_2d.emitting:
		await gpu_particles_2d.finished
		gpu_particles_2d.emitting = false
	gpu_particles_2d.emitting = false


func accelerate_to_vial():
	check_particles()
	if owner_node2d == null:
		return
	
	var vials = get_tree().get_nodes_in_group("exprience_vial") as Array
	if vials.size() == 0:
		check_particles()
		animation_player.stop()
		sprite_2d.change_sprite_0()
		return 
	
	#animation_player.play("walk")
	
	vials.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(owner_node2d.global_position)
		var b_distance = b.global_position.distance_squared_to(owner_node2d.global_position)
		return a_distance < b_distance
	)
	var target_vail = vials[0] as Node2D
	target_position = target_vail.global_position + Vector2(randf_range(-30,30),-40)
	var direction = (target_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)
	

func accelerate_in_direction(direction:Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity , 1-exp(-acceleration * get_process_delta_time()))
	if should_walk:
		animation_player.play("walk")


func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body : CharacterBody2D):
	if should_walk:
		character_body.velocity = velocity
		character_body.move_and_slide()
		velocity = character_body.velocity
		if target_position == null :
			return
		elif character_body.global_position.distance_to(target_position) < 10:
			if not is_playing_inhale :
				check_particles()
				is_playing_inhale = true
				arrived.emit()


func on_arrived():
	should_walk = false
	animation_player.stop()
	sprite_2d.change_sprite_3()
	#print("before inhale")
	animation_player.play("inhale")
	#print("333")
	timer.start()
	await timer.timeout
	collision_shape_2d.disabled = true
	is_playing_inhale = false
	should_walk = true
	#print("2")
	
