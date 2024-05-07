extends Node
class_name HealthComponent

@export var max_health : float

var current_health

signal died
signal health_changed
signal health_healed
signal health_damaged

# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = max_health


func damage(damage_amount:float):
	current_health = min(max(current_health-damage_amount,0),max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_damaged.emit()
	elif damage_amount < 0:
		health_healed.emit()
	Callable(check_death).call_deferred()


func get_health_percent():
	if current_health <= 0:
		return 0
	return min(current_health / max_health,1)
	

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
