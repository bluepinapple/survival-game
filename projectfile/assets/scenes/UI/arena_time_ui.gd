extends CanvasLayer


@export var arena_time_manage:Node
@onready var label = %Label

func _process(delta):
	if arena_time_manage == null:
		return
	var time_elapsed = arena_time_manage.get_time_elapsed()
	
	label.text = format_seconds_to_string(time_elapsed)


func format_seconds_to_string(seconds:float):
	var minus = floor(seconds/60)
	var remaining_seconds = seconds - (minus * 60)
	
	return ("%02d" % int(minus)) + ":" + ("%02d" % floor(remaining_seconds))
	
