extends KinematicBody2D

var velocity = Vector2(0, 96) # max velocity
var power = 1.0 # set in player scene
var acceleration = 1.0

func _ready():
	velocity = velocity.rotated($".".rotation)
	velocity += velocity * power * 3
	velocity *= -1 # minus to flip the vector

func _on_Area2D_body_entered(body):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _physics_process(delta):
	velocity =  move_and_slide(velocity)

