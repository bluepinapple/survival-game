extends Node

@export_range(0,1) var drop_perenct:float
@export var vial_scene : PackedScene
@export var helath_component : Node

func _ready():
	(helath_component as HealthComponent).died.connect(on_died)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
	
func on_died():
	if randf() > drop_perenct:
		return
	if vial_scene == null:
		return
	if not owner is Node2D:
		return
	
	var spwan_position = (owner as Node2D).global_position
	var vial_instance = vial_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	vial_instance.global_position = spwan_position
	

func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id == "vial_drop_rate":
		drop_perenct =min(drop_perenct+current_upgrades["vial_drop_rate"]["quantity"]* .1,1) 
		#print(owner,"+",drop_perenct)
