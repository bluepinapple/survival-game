extends PanelContainer

signal selected

@onready var name_label : Label = $%NameLabel
@onready var description_label : Label = $%DescriptionLabel
@onready var progress_bar = $MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ProgressBar
@onready var purchase_button = $MarginContainer/VBoxContainer/PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var purchase_amount_label = %PurchaseAmountLabel

var upgrade : MetaUpgrade

func _ready():
	GameEvents.currency_changed.connect(on_currency_changed)
	purchase_button.pressed.connect(on_purchase_pressed)
	#gui_input.connect(on_gui_input)


func set_meta_upgrade(upgrade:MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()
	

func update_progress():
	var curent_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		curent_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	var is_maxed = curent_quantity >= upgrade.max_quantity 
	var currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent = currency / upgrade.exprience_cost
	percent = min(percent,1)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "售罄"
	progress_label.text = str(currency)+"/"+str(upgrade.exprience_cost)
	purchase_amount_label.text = "%d" % curent_quantity


func select_card():
	$AnimationPlayer.play("selected")


func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.exprience_cost
	MetaProgression.save()
	GameEvents.emit_currency_changed()
	select_card()
	get_tree().call_group("meta_upgrade_card","upgrade_progress")
	update_progress()
	

func on_currency_changed():
	update_progress()
