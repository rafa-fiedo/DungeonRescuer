extends StaticBody2D

enum BoxFilling {Potion, Empty, Key} # count matters

signal box_opened

var is_opened = false

func _ready():
	pass
	
func _input(event):
	if is_opened:
		return
	if event.is_action_pressed("game_use") && len($PlayerDetector.get_overlapping_bodies()) > 0:
		emit_signal("box_opened", $".")
		is_opened = true
		
func open_box(box_filling):
	if box_filling == BoxFilling.Key:
		$AnimationPlayer.play("BoxKey")
	elif box_filling == BoxFilling.Potion:
		$AnimationPlayer.play("BoxPotion")
	else:
		$AnimationPlayer.play("BoxEmpty")
