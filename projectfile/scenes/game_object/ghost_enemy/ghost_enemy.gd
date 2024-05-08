extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var hurt_box = %HurtCollision

func _ready():
	$HealthComponent.health_damaged.connect(on_health_damaged)

func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)


func ghost_fade():
	hurt_box.disabled = !hurt_box.disabled
	
	
func on_health_damaged():
	pass
