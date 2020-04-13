extends StaticBody2D

var is_switched = false
var is_body_inside = false

signal switched_on

func _ready():
	pass

func _on_PlayerDetector_body_entered(body):
	is_body_inside = true


func _on_PlayerDetector_body_exited(body):
	is_body_inside = false

func _physics_process(delta):
	
	if Input.is_action_just_pressed("game_use") and is_body_inside:
		emit_signal("switched_on")
		$Sprite.frame = 1
	
