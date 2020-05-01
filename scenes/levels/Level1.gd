extends Node2D


func _ready():
	pass


func _on_DialoguePlayer_last_dialogue_finished():
	$NPC/DialoguePlayer.queue_free()
	$EndTimer.start()


func _on_EndTimer_timeout():
	$AnimationPlayer.play("EndAnimation")
	
func reload_scene():
	var err = get_tree().reload_current_scene()
	if err != OK:
		print("error during reloading scene on level1")

func start_autodestraction():
	pass
