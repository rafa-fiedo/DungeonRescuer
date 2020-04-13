extends Area2D

export(PackedScene) var next_scene = null

func _ready():
	pass

func _on_Stairs_body_entered(body):
	if next_scene:
		get_tree().change_scene_to(next_scene)
	else:
		print("no scene detected")

func _on_Stairs_body_exited(body):
	pass
	
func set_active(active):
	$".".visible = active
	set_physics_process(active)
	set_process(active)
	set_process_input(active)
