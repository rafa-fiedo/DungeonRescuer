extends KinematicBody2D

enum State {STOP, ACTIVE}

export(float) var speed = 52 # pixel per seconds
export(State) var state = State.STOP

var velocity = Vector2(0, 0)

var started_pos = Vector2(0, 0) # position to back after chase is failed
var started_velocity = Vector2(0, 0)

var max_hp = 134.0
var hp = max_hp

signal die

func _ready():
	velocity = Vector2(speed, 0)
	
	if state == State.STOP:
		$CollisionShape2D.disabled = true
		$TrapDetector.monitorable = false
		$TrapDetector.monitoring = false
		visible = false

func _on_TrapDetector_area_entered(area):
	area.get_parent().stop_trap()

func _on_TrapDetector_area_exited(area):
	area.get_parent().start_trap()

func _physics_process(_delta):
	if state == State.STOP:
		return
	set_sprites()
	
	var player_node = get_tree().current_scene.find_node("Player")
	
	var speed_multi = max(8, speed * (1.0 - (hp / max_hp)))
	
	velocity = $Center.global_position.direction_to(player_node.get_center()) * speed_multi
	
	if $Center.global_position.distance_to(player_node.global_position) < 10:
		return
	
	velocity = move_and_slide(velocity)

func active():
	state = State.ACTIVE
	$CollisionShape2D.disabled = false
	$TrapDetector.monitorable = true
	$TrapDetector.monitoring = true
	visible = true

func attack():
	if state == State.STOP:
		return
	$Character/Anim.play("Attack")
	return 1
	
	# it should be "HIT", TODO in refactor
func die(): 
	if state == State.STOP:
		return 
		
	$Character/AnimHit.play("Hit")
	hp -= 15
	
	if hp < 0:
		$CollisionShape2D.disabled = true
		$Character.die_animation()
		
		emit_signal("die")
		
		state = State.STOP

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

