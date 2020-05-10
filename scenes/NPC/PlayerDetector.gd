extends Area2D

signal player_use

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("game_use") && len(get_overlapping_bodies()) > 0:
		emit_signal("player_use")
		
