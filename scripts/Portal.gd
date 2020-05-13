extends Area2D

export(PackedScene) var next_scene = null

var is_working = true

func _ready():
	pass

func _on_Stairs_body_entered(_body):
	if !is_working:
		return

	SceneTranslator.play("EndOfScene")
	$Timer.start(SceneTranslator.scene_change_time)
	$Sound.play()
	

func _on_Stairs_body_exited(_body):
	pass

func _on_Timer_timeout():
	if next_scene:
		var err = get_tree().change_scene_to(next_scene)
		if err == OK:
			Global.reset_data()
		else:
			print("error loading stairs scene")
	else:
		print("no scene detected")

func set_active(active):
	$".".visible = active
	set_physics_process(active)
	set_process(active)
	set_process_input(active)
	
	is_working = active



