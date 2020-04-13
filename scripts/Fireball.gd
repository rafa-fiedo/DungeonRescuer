extends KinematicBody2D

var velocity = Vector2(0, 96) # max velocity
var power = 1.0 # set in player scene
var acceleration = 1.0

func _ready():
	velocity = velocity.rotated($".".rotation)
	velocity += velocity * power * 3
	velocity *= -1 # minus to flip the vector
	

func _on_Area2D_body_entered(body):
	if body.has_method("die"):
		body.call_die()
		
	call_deferred("die")
	
func die():
	velocity = Vector2(0, 0)
	$Area2D.monitorable = false
	$Area2D.monitoring = false
	
	$CPUParticles2D.emitting = false
	$Sprite.visible = false
	$DieEffect.emitting = true
	$AnimationPlayer.play("Die")
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _physics_process(_delta):
	velocity =  move_and_slide(velocity)

