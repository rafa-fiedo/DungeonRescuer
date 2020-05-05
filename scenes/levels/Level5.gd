extends Node2D

export(PackedScene) var orc_mini_scene = null
export(PackedScene) var box_scene = null

var box_opened = 0

func _ready():
	randomize()
	print(randi() % 344)
	
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
	box_opened += 1
