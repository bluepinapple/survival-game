extends CanvasLayer

@export var exprience_manager : Node
@onready var progress_bar = $%Exprience_Bar

func _ready():
	progress_bar.value = 0
	exprience_manager.exprience_update.connect(on_exprience_update)

func on_exprience_update(current_exprience:float , target_exprience:float):
	var percent = current_exprience / target_exprience
	progress_bar.value = percent
