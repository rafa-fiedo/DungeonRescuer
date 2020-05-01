extends Area2D
class_name BasicUseArea2D

signal player_use

var is_used = false

func _ready():
	pass
	
func _input(event):
	if is_used:
		return 
	if len(get_overlapping_bodies()) == 0:
		return
		
	if event.is_action_pressed("game_use"):
		emit_signal("player_use")
		is_used = true
