extends Node2D

@onready var play_collision_shape = $PlayerPickupArea2D/CollisionShape2D
@onready var chest_collision_shape = $ChestPickupArea2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D
@onready var random_audio_stream_player_2d_component = $RandomAudioStreamPlayer2DComponent

var chest : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerPickupArea2D.area_entered.connect(on_player_area_entered)
	$ChestPickupArea2D.area_entered.connect(on_chest_area_entered)


func tween_collect_to_player(percent :float,start_position:Vector2):
	var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null :
		return
	
	global_position = start_position.lerp(player.global_position,percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + rad_to_deg(90)
	rotation = lerp_angle(rotation,target_rotation,1-exp(-2 * get_process_delta_time()))


func tween_collect_to_chest(percent :float,start_position:Vector2):
	if chest == null :
		return
	
	global_position = start_position.lerp((chest.global_position+Vector2(0,-20)),percent)
	var direction_from_start = chest.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + rad_to_deg(90)
	rotation = lerp_angle(rotation,target_rotation,1-exp(-2 * get_process_delta_time()))


func collect():
	GameEvents.emit_exprience_vial_collected(1)
	queue_free()


func cheat():
	GameEvents.emit_exprience_vial_cheated(1)
	queue_free()
	
func disable_collsion():
	play_collision_shape.disabled = true
	
	
func on_player_area_entered(other_area:Area2D):
	Callable(disable_collsion).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect_to_player.bind(global_position),0.0,1.0,.5)\
	.set_ease(tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d,"scale",Vector2.ZERO,.05).set_delay(.45)
	tween.chain()
	tween.tween_callback(collect)
	
	random_audio_stream_player_2d_component.play_random()


func on_chest_area_entered(other_area:Area2D):
	chest = other_area
	
	Callable(disable_collsion).call_deferred()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect_to_chest.bind(global_position),0.0,1.0,.5)\
	.set_ease(tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_2d,"scale",Vector2.ZERO,.05).set_delay(.45)
	tween.chain()
	tween.tween_callback(cheat)
	
	$RandomAudioStreamPlayer2DComponent.play_random()
