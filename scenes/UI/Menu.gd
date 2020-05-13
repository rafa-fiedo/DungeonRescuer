extends Control

var selected_level = 1

var scenes = [
	load("res://scenes/levels/Level1.tscn"),
	load("res://scenes/levels/Level2.tscn"),
	load("res://scenes/levels/Level3.tscn"),
	load("res://scenes/levels/Level4.tscn"),
	load("res://scenes/levels/Level5.tscn"),
]

func _ready():
	MusicController.stop()

func _on_Next_pressed():
	selected_level += 1
	if selected_level > 5:
		selected_level = 5
	
	change_level_text()

func _on_Previous_pressed():
	selected_level -= 1
	if selected_level < 1:
		selected_level = 1
		
	change_level_text()

func change_level_text():
	$RichTextLabel.bbcode_text = "[center]" + str(selected_level)


func _on_TextButton_pressed():
	var err = get_tree().change_scene_to(scenes[selected_level - 1])
	if err == OK:
		Global.reset_data()
	else:
		print("error loading stairs scene")
