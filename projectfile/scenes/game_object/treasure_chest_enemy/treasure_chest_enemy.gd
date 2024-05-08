extends CharacterBody2D

@onready var velocity_component = $ChestVelocityComponent
@onready var visuals = $Visuals
@onready var gpu_particles_2d = $GPUParticles2D
@onready var collision_shape_2d = $PickupArea2D/CollisionShape2D

var is_moving = false

func _ready():
	check_particles()
	collision_shape_2d.disabled = true
	$HealthComponent.health_damaged.connect(on_health_damaged)


func check_particles():
	if gpu_particles_2d.emitting:
		await gpu_particles_2d.finished
		gpu_particles_2d.emitting = false
	gpu_particles_2d.emitting = false
		

func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_vial()
	else :
		velocity_component.decelerate()
	
	velocity_component.accelerate_to_vial()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)


func set_is_moving(moving : bool):
	is_moving = moving


func on_health_damaged():
	pass
