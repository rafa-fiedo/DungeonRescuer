extends KinematicBody2D

signal try_open_door

func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("game_use") and $PlayerDetector.get_overlapping_bodies():
		emit_signal("try_open_door")

func open_door():
	$Sound.play()
	$Sprite.frame = 1
	z_index = 10
	$CollisionShape2D.disabled = true
