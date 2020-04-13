extends Control

export(float) var character_speed = 0.05

var character_visible = 0
var waiting_for_any_key = false

signal next_dialogue

func _ready():
	hide()
	
func _process(delta):

	if waiting_for_any_key:
		if Input.is_action_just_pressed("game_use") || Input.is_action_just_pressed("game_shoot"):
			waiting_for_any_key = false
			emit_signal("next_dialogue")
	else:
		if Input.is_action_just_pressed("game_use") || Input.is_action_just_pressed("game_shoot"):
			if character_visible <= len($NinePatchRect/Text.text):
				character_visible = len($NinePatchRect/Text.text)
	
	
func show_dialogue(text):
	show()
	character_visible = 0
	$AnimationPlayer.play("Idle")
	$NinePatchRect/Text.visible_characters = 0
	$NinePatchRect/Text.text = text
	$CharacterSpeed.start(character_speed)

func _on_CharacterSpeed_timeout():
	character_visible += 1
	
	if len($NinePatchRect/Text.text) <= character_visible:
		$NinePatchRect/TextureRect.visible = true
		$AnimationPlayer.play("PressKey")
		waiting_for_any_key = true
		
	$NinePatchRect/Text.visible_characters = character_visible
