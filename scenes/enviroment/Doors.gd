extends KinematicBody2D


func _ready():
	pass
	
func _input(event):
	if event.is_action_pressed("game_use") and $PlayerDetector.get_overlapping_bodies():
		print("door click")
		$Sprite.frame = 1
		$CollisionShape2D.disabled = true
