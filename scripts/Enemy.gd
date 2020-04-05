extends KinematicBody2D

enum State {MOVE, STOP}

export(bool) var is_moving = true
export(bool) var start_left = true
export(float) var speed = 32 # pixel per seconds

var state = State.MOVE
var velocity = Vector2(0, 0)

func _ready():
	if !is_moving:
		state = State.STOP
	velocity = Vector2(speed, 0)
	if start_left:
		velocity.x = -velocity.x
	
func _physics_process(delta):
	set_sprites()
	
	if $RayLeft.is_colliding():
		velocity.x = abs(velocity.x)
	if $RayRight.is_colliding():
		velocity.x = -abs(velocity.x)
		
	
	velocity = move_and_slide(velocity)


func set_sprites():
	if velocity.x > 0:
		$Character.get_node("Sprite").flip_h = false
		# $CollisionShape2D.position.x = 1
	else:
		$Character.get_node("Sprite").flip_h = true
		# $CollisionShape2D.position.x = -1
