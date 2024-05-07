extends CharacterBody2D


@onready var damage_interval_timer = $DamageIntervalTimer
@onready var collision_area = $CollisionArea2D
@onready var health_component = $PlayerHealthComponent
@onready var health_bar = $ProgressBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var pickup_area = $PickupArea2D
@onready var exprience_manager = $ExprienceManager
@onready var gpu_particles_2d = $HealingParticle

var number_colliding_body = 0
var hurt_count = 0
var max_speed = 130
var acceleration_smoothing = 15

func _ready():
	update_health_display()
	
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_add)
	collision_area.body_entered.connect(on_body_entered)
	collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timeout)
	health_component.health_changed.connect(on_health_changed)
	health_component.health_healed.connect(on_health_healed)
	health_component.health_damaged.connect(on_health_damaged)
	

func _process(delta):
	var direction = get_movement_vecter()
	var target_velocity = direction * max_speed
	
	velocity = velocity.lerp(target_velocity,1-exp(-delta*acceleration_smoothing))
	
	#print(damage_interval_timer.wait_time)
	move_and_slide()
	if direction.x != 0 || direction.y != 0:
		animation_player.play("walk")
	else :
		animation_player.play("RESET")
	
	var move_sign = sign(direction.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)


func get_movement_vecter():
	
	var x_movement = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	
	return Vector2(x_movement,y_movement).normalized()


func check_deal_damage():
	if number_colliding_body == 0:
		return
	health_component.damage(1)
	damage_interval_timer.start()
	#print(hurt_count)
	print(health_component.current_health)

func update_health_display():
	health_component.set_current_health()
	health_bar.value = health_component.get_health_percent()

func check_particle():
	if gpu_particles_2d.emitting:
		await gpu_particles_2d.finished
		gpu_particles_2d.emitting = false

func on_body_entered(other_body:Node2D):
	number_colliding_body += 1
	if hurt_count == 0:
		hurt_count += 1
		check_deal_damage()
		damage_interval_timer.start()
	
	
func on_body_exited(other_body:Node2D):
	number_colliding_body -= 1
	
	
func on_damage_interval_timeout():
		hurt_count = 0
		check_deal_damage()


func on_health_changed():
	update_health_display()
	

func on_health_healed():
	gpu_particles_2d.emitting = true
	check_particle()
	

func on_health_damaged():
	$RandomAudioStreamPlayer2DComponent.play_random()
	GameEvents.emit_player_damaged()


func on_ability_upgrade_add(ability_upgrade : AbilityUpgrade , current_upgrades : Dictionary):
	if ability_upgrade.id == "axe" :
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_contreller_scene.instantiate())
	
	elif  ability_upgrade.id == "heal_up":
		health_component.damage(-10)
		
	elif  ability_upgrade.id == "speed_up":
		max_speed += 20
		acceleration_smoothing += 2
	
	elif ability_upgrade.id == "pickup_area_up":
		pickup_area.scale += Vector2.ONE
