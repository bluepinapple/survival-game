extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var timer = $Timer
@onready var marker_2d = $Visuals/Wand/Marker2D
@onready var wand_animation_player = $WandAnimationPlayer

@export var bullet : PackedScene

var is_moving = false
var is_shooting = false

func _ready():
	$HealthComponent.health_damaged.connect(on_health_damaged)

func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else :
		velocity_component.decelerate()
	
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if global_position.distance_to(player.global_position)  < 90:
		shoot()
	
	#以下代码用来给sprite水平翻转
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)

func shoot():
	if not is_shooting:
		is_shooting = true
		is_moving = false
		wand_animation_player.play("shoot")
		var bullet_instance = bullet.instantiate()
		get_parent().add_child(bullet_instance)
		bullet_instance.position = marker_2d.global_position
		bullet_instance.accelerate_to_player(bullet_instance.position)
		timer.start()
		await timer.timeout
		is_moving = true
		is_shooting = false

func set_is_moving(moving : bool):
	is_moving = moving


func on_health_damaged():
	pass
