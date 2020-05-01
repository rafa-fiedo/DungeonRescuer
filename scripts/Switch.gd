extends KinematicBody2D

var is_switched = false
var is_body_inside = false

signal switched_on

func _ready():
	pass

func _on_PlayerDetector_body_entered(_body):
	is_body_inside = true


func _on_PlayerDetector_body_exited(_body):
	is_body_inside = false
	
func _input(event):
	if event.is_action_pressed("game_use") and is_body_inside and !is_switched:
		emit_signal("switched_on")
		$Sprite.frame = 1
		is_switched = true
