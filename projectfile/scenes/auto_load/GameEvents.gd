extends Node

signal exprience_vial_collected(number:float)
signal exprience_vial_cheated(number:float)
signal ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrade:Dictionary)
signal player_damaged
signal currency_changed


func emit_exprience_vial_collected(number:float):
	exprience_vial_collected.emit(number)


func emit_exprience_vial_cheated(number:float):
	exprience_vial_cheated.emit(number)


func emit_upgrade_added(upgrade:AbilityUpgrade,current_upgrade:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrade)
	

func emit_player_damaged():
	player_damaged.emit()


func emit_currency_changed():
	currency_changed.emit()
