extends Node2D

export(PackedScene) var orc_mini_scene = null
export(PackedScene) var box_scene = null

var box_opened = 0

var player_has_key = false

func _ready():
	randomize()
	
	$Skull.visible = false
	
	
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

	var box = box_scene.instance()
	box.position = pos_node.global_position
	box.connect("box_opened", $".", "_on_Box_box_opened")
	add_child(box)

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

func _on_trigger_right_corridor_body_entered(body):
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


func _on_trigger_boss_room_entry_body_entered(body):
	$BlockBossTilemap.visible = true
	$BlockBossTilemap.set_collision_layer_bit(2, true)
	if has_node("BasicTilemap"):
		$BasicTilemap.queue_free()


func _on_trigger_test_boss_body_entered(body):
	$Player.speed_up_fire()
