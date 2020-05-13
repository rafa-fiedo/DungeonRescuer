extends KinematicBody2D

enum State {MOVE, STOP, CHASE}

export(bool) var is_moving = true
export(bool) var start_left = true
export(float) var speed = 32 # pixel per seconds
export(bool) var delete_him = false
export(bool) var moving_vertical = false

var state = State.MOVE
var velocity = Vector2(0, 0)

var started_pos = Vector2(0, 0) # position to back after chase is failed
var started_velocity = Vector2(0, 0)

var play_sound = false

func _ready():
	randomize()
	if has_node("SoundAnimationTimer"):
		$SoundAnimationTimer.start(randf())
	
	if is_moving:
		if moving_vertical:
			velocity = Vector2(0, speed)
			$RayLeft.rotate(deg2rad(90))
			$RayRight.rotate(deg2rad(90))
		else:
			velocity = Vector2(speed, 0)
		
	if start_left:
		velocity.x = -velocity.x
		
	if(delete_him):
		queue_free()

func _on_Character_attack():
	$AttackSound.play()

func _on_SoundAnimationTimer_timeout():
	play_sound = true

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
		if moving_vertical:
			velocity = Vector2(0, 1) * speed
		else:
			velocity = Vector2(1, 0) * speed
	if $RayRight.is_colliding():
		if moving_vertical:
			velocity = Vector2(0, -1) * speed
		else:
			velocity = Vector2(-1, 0) * speed
		
	var bodies = $PlayerDetector.get_overlapping_bodies()
	if len(bodies) > 0:
		$RayToPlayer.cast_to = bodies[0].get_center() - $RayToPlayer.global_position
	
	var faster_run_sounds = false
	if !$RayToPlayer.is_colliding() and len(bodies) > 0: # checking enviroment
		state = State.CHASE
		velocity = global_position.direction_to(bodies[0].get_center()) * speed * 2
		if has_node("AnimationPlayer"):
			$AnimationPlayer.playback_speed = 2.0
			faster_run_sounds = true
		
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
	
	if has_node("AnimationPlayer"):
		if velocity.x != 0 and play_sound:
			if $AnimationPlayer.current_animation != "Run":
				$AnimationPlayer.play("Run") # only for audio
				if !faster_run_sounds:
					$AnimationPlayer.playback_speed = 1.0
		else:
			$AnimationPlayer.stop()

	
	velocity = move_and_slide(velocity)
	
func attack():
	state = State.STOP
	$Character/Anim.play("Attack")
	return 1
	
func die():
	if state == State.STOP:
		return 
	state = State.STOP
	$CollisionShape2D.disabled = true
	$RayLeft.enabled = false
	$RayRight.enabled = false
	$RayToPlayer.enabled = false
	$PlayerDetector.monitorable = false
	$PlayerDetector.monitoring = false
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
