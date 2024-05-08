extends Node

@export var upgrade_pool : Array[AbilityUpgrade]
@export var exprience_manager : Node
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {}
var upgrades_pool : weightedTable = weightedTable.new()

#以下为斧头的升级
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_axe_rate = preload("res://resources/upgrades/axe-rate.tres")
var upgrade_axe_scale_up = preload("res://resources/upgrades/axe_scale_up.tres")
var upgrade_axe_being_time_up = preload("res://resources/upgrades/axe_being_time_up.tres")
#以下为剑的升级
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_sword_amount = preload("res://resources/upgrades/sword_amount.tres")
var upgrade_sword_scale_up = preload("res://resources/upgrades/sword_scale_up.tres")
#以下为玩家的属性升级
var upgrade_heal_up = preload("res://resources/upgrades/heal_up.tres")
var upgrade_speed_up = preload("res://resources/upgrades/speed_up.tres")
var upgrade_pickup_area_up = preload("res://resources/upgrades/pickup_area_up.tres")
var upgrade_vial_drop_rate = preload("res://resources/upgrades/vial_drop_rate.tres")

func _ready():
	upgrades_pool.add_items(upgrade_axe,15)
	upgrades_pool.add_items(upgrade_sword_damage,10)
	upgrades_pool.add_items(upgrade_sword_rate,10)
	upgrades_pool.add_items(upgrade_heal_up,10)
	upgrades_pool.add_items(upgrade_speed_up,10)
	upgrades_pool.add_items(upgrade_sword_amount,10)
	upgrades_pool.add_items(upgrade_sword_scale_up,10)
	upgrades_pool.add_items(upgrade_pickup_area_up,10)
	upgrades_pool.add_items(upgrade_vial_drop_rate,8)
	
	exprience_manager.level_up.connect(on_level_up)


func update_upgrade_pool(chosen_upgrade : AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id :
		upgrades_pool.add_items(upgrade_axe_damage,10)
		upgrades_pool.add_items(upgrade_axe_rate,10)
		upgrades_pool.add_items(upgrade_axe_scale_up,10)
		upgrades_pool.add_items(upgrade_axe_being_time_up,10)
	

func pick_upgrades():
	var chosen_upgrades:Array[AbilityUpgrade] = []
	for i in 3:
		if upgrades_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrades_pool.pick_item() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		#upgrades_pool = upgrades_pool.filter(func(upgrade):return upgrade.id != chosen_upgrade.id)
	
	return chosen_upgrades


func apply_upgrade(upgrade:AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade :
		current_upgrades[upgrade.id]={
			"resource":upgrade,
			"quantity":1
		}
	else :
		current_upgrades[upgrade.id]["quantity"] += 1
	#print(current_upgrades)
	
	if upgrade.max_quantity >= 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrades_pool.remove_item(upgrade)
			#upgrade_pool = upgrade_pool.filter(func(pool_upgrade):return pool_upgrade.id != upgrade.id)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_upgrade_added(upgrade,current_upgrades)
	

func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(current_level:int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrade(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
