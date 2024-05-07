extends CanvasLayer

signal transition_halfway

@onready var animation_player = $AnimationPlayer


func transition():
	animation_player.play("in")
	await transition_halfway
	animation_player.play("out")


func emit_transtioned_halfway():
	transition_halfway.emit()
	
