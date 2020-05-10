extends Node

var player_data = null
var scene_checkpoint = null

func _ready():
	pass
	
func _process(_delta):
	
	if Input.is_action_just_pressed("restart"):
		# TODO error handle
		var _result = get_tree().reload_current_scene()
		print("scene restarted")

func reset_data():
	player_data = null
	scene_checkpoint = null

class PlayerData:
	var _position = Vector2.ZERO
	var _spell_fire_avaliable = false
	var _fire_speed_up = false
	
	func _init(position, spell_fire_avaliable, fire_speed_up):
		_position = position
		_spell_fire_avaliable = spell_fire_avaliable
		_fire_speed_up = fire_speed_up
	
	
