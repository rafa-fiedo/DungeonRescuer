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
	
func _physics_process(_delta):
	if state == State.STOP:
		return
	set_sprites()
	
	if $RayLeft.is_colliding():
		velocity.x = abs(velocity.x)
	if $RayRight.is_colliding():
		velocity.x = -abs(velocity.x)
		
	
	velocity = move_and_slide(velocity)
	
func die():
	state = State.STOP
	$CollisionShape2D.disabled = true
	$RayLeft.enabled = false
	$RayRight.enabled = false
	$Character.die_animation()

func call_die():
	# body_set_shape_disabled: Can't change this state while flushing queries. 
	# Use call_deferred() or set_deferred() to change monitoring state instead.
	call_deferred("die") 

func set_sprites():
	if velocity.x > 0:
		$Character.get_node("Sprite").flip_h = false
		$CollisionShape2D.position.x = 0
	else:
		$Character.get_node("Sprite").flip_h = true
		$CollisionShape2D.position.x = -2
