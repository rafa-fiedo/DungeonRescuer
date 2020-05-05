extends Area2D

signal use_signal

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("game_use") && len(get_overlapping_bodies()) > 0:
		emit_signal("use_signal")
