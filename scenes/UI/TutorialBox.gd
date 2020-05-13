extends CanvasLayer

var used = false

func _ready():
	pass
	$NinePatchRect.visible = false

#func _input(event):
#	if Input.is_action_just_pressed("use_spell_1"):
#		for input_event_key in InputMap.get_action_list("game_use"):
#			print (input_event_key.scancode)
#			print (OS.get_scancode_string(input_event_key.scancode))

func hide():
	$NinePatchRect.visible = false
	
func hide_using_animation():
	$AnimationPlayer.play("FadeOut")
	
func show_first_tutorial():
	if used:
		return
	
	Input.is_action_just_pressed("game_up")
	
	var move_keys = OS.get_scancode_string(InputMap.get_action_list("game_up")[0].scancode) + "," \
		+ OS.get_scancode_string(InputMap.get_action_list("game_left")[0].scancode) + "," \
		+ OS.get_scancode_string(InputMap.get_action_list("game_down")[0].scancode) + "," \
		+ OS.get_scancode_string(InputMap.get_action_list("game_right")[0].scancode)
		
	var interact_key = OS.get_scancode_string(InputMap.get_action_list("game_use")[0].scancode)
	
	var text = "[center]Use [color=#4ba747]" + move_keys + "[/color]" + ' to move \n' \
			+ "[center]Use [color=#4ba747]" + interact_key + "[/color]" + ' to interact with NPC and objects) \n'
			
	$NinePatchRect/RichTextLabel.bbcode_text = text
	
	$NinePatchRect.visible = true
	$AnimationPlayer.play("FadeIn")
	used = true

func show_spells_tutorial():
	if used:
		return
	
	var spells_keys = OS.get_scancode_string(InputMap.get_action_list("spell_1")[0].scancode) + "," \
		+ OS.get_scancode_string(InputMap.get_action_list("spell_2")[0].scancode)
		
	var spell_use = get_mouse_string(InputMap.get_action_list("use_spell_1")[0])
	
	var text = "[center]Use [color=#4ba747]" + spells_keys + "[/color]" + ' keys to change your spells \n' \
			+ "[center]Use [color=#4ba747]" + spell_use + "[/color]" + ' to cast fire (when fire rod is active) \n'
			
	$NinePatchRect/RichTextLabel.bbcode_text = text
	
	$NinePatchRect.visible = true
	$AnimationPlayer.play("FadeIn")
	used = true

func get_mouse_string(mouse_input):
	# https://docs.godotengine.org/en/3.1/classes/class_@globalscope.html#class-globalscope-constant-button-mask-xbutton2
	
	match mouse_input.button_index:
		1:
			return "Left Mouse Button"
		2: 
			return "Right Mouse Button"
		3: 
			return "Middle Mouse Button"
		
