extends Area2D

export(bool) var working = true
export(bool) var disable_sound = false

func _ready():
	if working:
		$AnimationPlayer.play("Idle")

func turn_on_collisions():
	monitoring = true
	monitorable = true
	if !disable_sound:
		$Sound.play()
	
func turn_off_collision():
	monitoring = false
	monitorable = false
	
func stop_trap():
	call_deferred("turn_off_collision")
	$Sprite.frame = 0
	$AnimationPlayer.stop()
	
func start_trap():
	$AnimationPlayer.play("Idle")

func _on_Trap_body_entered(body):
	body.call_die()
