extends CanvasLayer

var menu_scene = load("res://scenes/UI/Menu.tscn")

func _ready():
	set_visible(false)
	
func _input(event):
	
	if event.is_action_pressed("game_exit"):
		get_tree().quit()
	
	if event.is_action_pressed("game_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if get_tree().current_scene.name == "Menu":
		return
	
	if event.is_action_pressed("game_pause"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused

func _on_Menu_pressed():
	get_tree().paused = false
	var err = get_tree().change_scene_to(menu_scene)
	if err == OK:
		Global.reset_data()
	else:
		print("error loading stairs scene")
		
	set_visible(false)
	
func _on_Continue_pressed():
	get_tree().paused = false
	set_visible(false)

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
