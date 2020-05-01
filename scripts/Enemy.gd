extends KinematicBody2D

enum State {MOVE, STOP, CHASE}

export(bool) var is_moving = true
export(bool) var start_left = true
export(float) var speed = 32 # pixel per seconds
export(bool) var delete_him = false

var state = State.MOVE
var velocity = Vector2(0, 0)

var started_pos = Vector2(0, 0) # position to back after chase is failed
var started_velocity = Vector2(0, 0)

func _ready():
	if is_moving:
		velocity = Vector2(speed, 0)
		
	if start_left:
		velocity.x = -velocity.x
		
	if(delete_him):
		queue_free()
		
func _on_PlayerDetector_body_entered(body):
	started_pos = global_position # it's creating new vector
	started_velocity = velocity
	$RayToPlayer.enabled = true
	$RayToPlayer.cast_to = body.get_center() - $RayToPlayer.global_position

func _on_PlayerDetector_body_exited(_body):
	$RayToPlayer.enabled = false
	$RayLeft.enabled = true
	$RayRight.enabled = true
	
func _physics_process(_delta):
	if state == State.STOP:
		return
	set_sprites()
	
	if $RayLeft.is_colliding():
		velocity = Vector2(1, 0) * speed
	if $RayRight.is_colliding():
		velocity = Vector2(-1, 0) * speed
		
	var bodies = $PlayerDetector.get_overlapping_bodies()
	if len(bodies) > 0:
		$RayToPlayer.cast_to = bodies[0].get_center() - $RayToPlayer.global_position
	
	if !$RayToPlayer.is_colliding() and len(bodies) > 0: # checking enviroment
		state = State.CHASE
		velocity = global_position.direction_to(bodies[0].get_center()) * speed * 2
		
	elif state == State.CHASE and started_pos:
		if global_position.distance_to(started_pos) < 1:
			started_pos = null
			velocity = started_velocity
			$RayLeft.enabled = true
			$RayRight.enabled = true
			state = State.MOVE
		else:
			velocity = global_position.direction_to(started_pos) * speed * 0.8
			$RayLeft.enabled = false
			$RayRight.enabled = false
	else:
		$RayLeft.enabled = true
		$RayRight.enabled = true
		
	

	
	velocity = move_and_slide(velocity)
	
func attack():
	state = State.STOP
	$Character/Anim.play("Attack")
	return 1
	
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
		$PlayerDetector/CollisionShape2D.rotation_degrees = 0
	else:
		$Character.get_node("Sprite").flip_h = true
		$CollisionShape2D.position.x = -2
		$PlayerDetector/CollisionShape2D.rotation_degrees = 180

