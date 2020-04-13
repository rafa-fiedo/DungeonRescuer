extends Node

func _ready():
	pass
	
func _process(_delta):
	
	if Input.is_action_just_pressed("restart"):
		# TODO error handle
		var _result = get_tree().reload_current_scene()
		print("scene restarted")
