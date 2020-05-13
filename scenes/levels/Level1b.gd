extends Node2D


func _ready():
	SceneTranslator.play("InitOfScene")
	MusicController.play_background()
	$Stairs.set_active(false)

func _on_Switch_switched_on():
	$Stairs.set_active(true)
	$NPC.current_dialogue_node_name = "DialoguePlayer_switch_on"
	$NPC.position.y -= 16*2
