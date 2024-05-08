extends CharacterBody2D

@export var max_speed :int = 300
@export var acceleration : float = 150

func _physics_process(delta):
	move_and_slide()
	get_tree().create_timer(1.5).timeout.connect(func on_timer_timeout():queue_free())


func accelerate_to_player(start_posistion : Vector2):	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var direction = (player.global_position - start_posistion).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction:Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity , 1-exp(-acceleration * get_process_delta_time()))


