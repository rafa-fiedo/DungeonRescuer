extends Area2D

export(PackedScene) var next_scene = null

func _ready():
	pass

func _on_Stairs_body_entered(_body):
	if next_scene:
		var err = get_tree().change_scene_to(next_scene)
		if err == OK:
			Global.reset_data()
		else:
			print("error loading stairs scene")
		
	else:
		print("no scene detected")

func _on_Stairs_body_exited(_body):
	pass
	
func set_active(active):
	$".".visible = active
	set_physics_process(active)
	set_process(active)
	set_process_input(active)
