extends Node2D

export(PackedScene) var orc_mini_scene = null
export(PackedScene) var box_scene = null
export(PackedScene) var end_screen = null

var box_opened = 0

var player_has_key = false

func _ready():
	MusicController.play_background()
	SceneTranslator.play("InitOfScene")
	randomize()
	
	if Global.player_data:
		$Player.load_data(Global.player_data)
		
	$Skull.visible = false
	
	if Global.scene_checkpoint in [1]:
		player_has_key = true
		$Skull.activate()
		$Skull.visible = true
		$torches/Torch.queue_free()
		$torches/Torch2.queue_free()
	
	for trap in $trapes/boss.get_children():
		trap.visible = false
		trap.stop_trap()
	
	# random mini orc places
	for positions in $enemies/left_corridor.get_children():
		var r = randi() % 3
		var pos_node = positions.get_child(r)

		var orc_mini = orc_mini_scene.instance()
		orc_mini.is_moving = false
		orc_mini.start_left = false
		orc_mini.position = pos_node.global_position

		add_child(orc_mini)
	
	# random box place
	var r = randi() % 3
	var pos_node = $boxes/left_corridor.get_child(r)
	
	if Global.scene_checkpoint in [1]:
		return # don't add box
			
	var box = box_scene.instance()
	box.position = pos_node.global_position
	box.connect("box_opened", $".", "_on_Box_box_opened")
	add_child(box)

func _on_Boss_die():
	for trap in $trapes/boss.get_children():
		trap.stop_trap()
		trap.visible = false
	
	MusicController.play_victory()
	$Player.set_position_to_move($positions/PosToGoAfterBoss)

func _on_Box_box_opened(box):
	box.open_box(box_opened)
	if box_opened == 0:
		$Player.speed_up_fire()
	
	if box_opened == 2:
		player_has_key = true
		$Skull.activate()
		$Skull.visible = true
		$torches/Torch.queue_free()
		$torches/Torch2.queue_free()
	
	box_opened += 1

func _on_trigger_right_corridor_body_entered(_body):
	if has_node("BasicTilemap2"):
		$BasicTilemap2.queue_free()

func _on_trigger_right_corridor_unlock_player_use():
	if has_node("BasicTilemap2"):
		$BasicTilemap2.queue_free()


func _on_Doors_try_open_door():
	if player_has_key:
		$Doors.open_door()
		if has_node("BlackSpriteAfterDoors"):
			$BlackSpriteAfterDoors.queue_free()


func _on_trigger_boss_room_entry_body_entered(_body):
	$BlockBossTilemap.visible = true
	$BlockBossTilemap.set_collision_layer_bit(2, true)
	if has_node("BasicTilemap"):
		$BasicTilemap.queue_free()
	$torches/boss_torches/Torch3.visible = true
	$torches/boss_torches/Torch4.visible = true


func _on_trigger_test_boss_body_entered(_body):
	$Player.speed_up_fire()

func _on_Wife_DialoguePlayer_last_dialogue_finished():
	$Player.set_active(false)
	$npcs/Path2D.start_path()
	$npcs/Path2D/PathFollow2D/NPC.visible = true
	
	MusicController.play_battle()
	
	$npcs/Wife/DialoguePlayer.queue_free()

func _on_Path2D_path_ended():
	$npcs/Path2D/PathFollow2D/NPC.activate()
	$npcs/Path2D/PathFollow2D/NPC/DialoguePlayer.start_dialogue()

# dialogue after NPC
func _on_DialoguePlayer_dialogue_finished():
	$Player.set_active(true)
	$Boss.active()
	$npcs/Path2D/PathFollow2D/NPC.deactivate_it()
	
	for torch in $torches/boss_torches.get_children():
		torch.visible = true
		
	for trap in $trapes/boss.get_children():
		trap.visible = true
		trap.start_trap()
		

func _on_Player_walked_to_position(_id):
	$npcs/PathAfterBoss/PathFollow2D/NPC.activate()
	$npcs/PathAfterBoss/PathFollow2D/NPC/DialoguePlayer.start_dialogue()
	$npcs/Path2D/PathFollow2D/NPC.queue_free()

func _on_DialoguePlayer_AfterBoss_dialogue_finished():
	$npcs/PathAfterBoss.start_path()

func _on_PathAfterBoss_path_ended():
	$npcs/Wife.queue_free()
	$npcs/WifeAfterBoss.activate()
	$npcs/WifeAfterBoss/DialoguePlayer.start_dialogue()


func load_scene_after_black():
	var err = get_tree().change_scene_to(end_screen)
	if err == OK:
		Global.reset_data()
	else:
		print("error loading stairs scene")

func _on_WifeAfterBoss_dialogue_finished():
	$AnimationPlayer.play("EndAnimation")
	$npcs/WifeAfterBoss/AnimationPlayer2.play("EndAnimation")
	$TurnOffLight.start(3.0)


func _on_TurnOffLight_timeout():
	for torch in $torches/boss_torches.get_children():
		torch.visible = false
		
func _on_CheckpointBeforeBoss_body_entered(_body):
	if player_has_key:
		Global.player_data = $Player.get_save_data()
		Global.scene_checkpoint = 1
