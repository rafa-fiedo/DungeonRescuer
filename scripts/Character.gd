extends Node2D

signal attack

func _ready():
	pass

func set_moving_animation(velocity):
	var anim_name = "Idle"
	if velocity.x != 0 || velocity.y != 0:
		anim_name = "Run"
		
	play_animation(anim_name)
		
func play_animation(new_animation):
	if new_animation == $Anim.current_animation:
		return
		
	$Anim.play(new_animation)
	
func set_active(value):
	set_process(value)
	set_process_input(value)

func die_animation():
	$Anim.play("Die")
