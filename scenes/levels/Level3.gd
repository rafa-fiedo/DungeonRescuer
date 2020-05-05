extends Node2D

var walk_speed_npc = 3 # in second
var npc_walking = false

signal npc_walked 

var count_fires = false
var fired_used = 0

func _ready():
	$Path2D/PathFollow2D.unit_offset = 0
	
	if Global.player_data:
		$Player.load_data(Global.player_data)
	
	if Global.scene_checkpoint == 1:
		$Path2D/PathFollow2D.unit_offset = 1
		$Path2D/PathFollow2D/NPC_after_power_up.visible = true
		$Path2D/PathFollow2D/NPC_after_power_up.activate()
		$Path2D/PathFollow2D/NPC_after_power_up.turn_around()
		$Statue.is_used = true
		

func _on_Player_fire_used():
	if count_fires:
		fired_used += 1

func _on_Statue_player_use():
	$Player.set_active(false)
	$AnimationPlayer.play("LightShake")
	npc_walking = true
	$Path2D/PathFollow2D/NPC_after_power_up.visible = true

func _on_Level3_npc_walked():
	$Player.is_fire_use = true
	npc_walking = false
	$Path2D/PathFollow2D/NPC_after_power_up.turn_around()
	$Path2D/PathFollow2D/NPC_after_power_up/DialoguePlayer.start_dialogue()
	$Path2D/PathFollow2D/NPC_after_power_up.activate()
	$NPC.queue_free()

	
func _on_DialoguePlayer_dialogue_finished():
	$Player.set_active(true)
	Global.player_data = $Player.get_save_data()
	Global.scene_checkpoint = 1
	$TutorialBox.show_spells_tutorial()
	count_fires = true

func _process(delta):
	
	if(fired_used > 1):
		$TutorialBox.hide_using_animation()
		fired_used = 0
		count_fires = false
	
	if npc_walking:
		$Path2D/PathFollow2D.unit_offset += delta / walk_speed_npc
		$Path2D/PathFollow2D/NPC_after_power_up.play_animation("Run")
		
		if($Path2D/PathFollow2D.unit_offset >= 1):
			emit_signal("npc_walked")
			$Path2D/PathFollow2D/NPC_after_power_up.play_animation("Idle")
		
