extends Node2D


func _ready():
	if Global.player_data:
		$Player.load_data(Global.player_data)
		
	if Global.scene_checkpoint in [1, 2]:
		$npcs/Path2D/PathFollow2D.unit_offset = 1
		$npcs/Path2D/PathFollow2D/NPC_First.visible = true
		$npcs/Path2D/PathFollow2D/NPC_First.activate()
		$triggers/trigger1.queue_free()
		$npcs/Path2D/PathFollow2D/NPC_First/DialoguePlayer.set_last_dialogue()

func _on_Path2D_path_ended():
	$npcs/Path2D/PathFollow2D/NPC_First.activate()
	$npcs/Path2D/PathFollow2D/NPC_First/DialoguePlayer.start_dialogue()
	
func _on_DialoguePlayer_dialogue_finished():
	$Player.set_active(true)
	

func _on_check_2_body_entered(_body):
	Global.player_data = $Player.get_save_data()
	Global.scene_checkpoint = 2

############################################## Triggers
func _on_trigger1_body_entered(_body):
	$Player.set_active(false)
	$npcs/Path2D.start_path()
	$npcs/Path2D/PathFollow2D/NPC_First.visible = true
	$triggers/trigger1.queue_free()
	
	# Global.player_data = $Player.get_save_data()
	Global.scene_checkpoint = 1
	
func _on_trigger_change_map_body_entered(_body):
	replace_map()
	$npcs/NPC_nearEnd.visible = true
	# $npcs/NPC_nearEnd.activate()
	$npcs/Path2D/PathFollow2D/NPC_First.queue_free()
	
func replace_map():
	$BasicTilemap.queue_free()
	$BasicTilemap2.visible = true
	$triggers/trigger_change_map.queue_free()
	$enemies/OrcMini.call_die()


func _on_trigger_hidden_passage_use_signal():
	replace_map()
	$triggers/trigger_hidden_passage.queue_free()
	$npcs/NPC_nearEnd.queue_free()
