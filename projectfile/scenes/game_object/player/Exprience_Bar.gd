extends ProgressBar

@onready var exprience_manager = $"../ExprienceManager"

func _ready():
	value = MetaProgression.get_upgrade_count("start_exprience")/7.0
	#print(value)
	exprience_manager.exprience_update.connect(on_exprience_update)

func on_exprience_update(current_exprience:float , target_exprience:float):
	var percent = current_exprience / target_exprience
	value = percent
