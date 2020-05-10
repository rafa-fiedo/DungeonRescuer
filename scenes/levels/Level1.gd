extends Node2D

export(PackedScene) var end_screen = null

func _ready():
	pass


func _on_DialoguePlayer_last_dialogue_finished():
	$NPC/DialoguePlayer.queue_free()
	$EndTimer.start()


func _on_EndTimer_timeout():
	$AnimationPlayer.play("EndAnimation")
	
func load_scene_after_black():
	var err = get_tree().change_scene_to(end_screen)
	if err == OK:
		Global.reset_data()
	else:
		print("error loading stairs scene")

func start_autodestraction():
	pass
