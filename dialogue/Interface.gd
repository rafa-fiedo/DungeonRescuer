extends CanvasLayer

export(float) var character_speed = 0.05

var character_visible = 0
var waiting_for_any_key = false

var keys_sounds = [load("res://resources/audio/sound_effects/keys/1.wav"), 
	load("res://resources/audio/sound_effects/keys/2.wav"), 
	load("res://resources/audio/sound_effects/keys/3.wav"), 
	load("res://resources/audio/sound_effects/keys/4.wav"), 
	load("res://resources/audio/sound_effects/keys/5.wav")]

signal next_dialogue

func _ready():
	$NinePatchRect.hide()
	
func _process(_delta):

	if waiting_for_any_key:
		if Input.is_action_just_pressed("game_use") || Input.is_action_just_pressed("game_shoot"):
			waiting_for_any_key = false
			emit_signal("next_dialogue")
	else:
		if Input.is_action_just_pressed("game_use") || Input.is_action_just_pressed("game_shoot"):
			if character_visible <= len($NinePatchRect/Text.text):
				character_visible = len($NinePatchRect/Text.text)
	
	
func show_dialogue(text):
	$NinePatchRect.show()
	character_visible = 0
	$AnimationPlayer.play("Idle")
	$NinePatchRect/Text.visible_characters = 0
	$NinePatchRect/Text.bbcode_text = text
	$CharacterSpeed.start(character_speed)

func _on_CharacterSpeed_timeout():
	character_visible += 1
	
	
	if len($NinePatchRect/Text.text) <= character_visible:
		$NinePatchRect/TextureRect.visible = true
		$AnimationPlayer.play("PressKey")
		waiting_for_any_key = true
	else:
		if character_visible % 2 == 0:
			var rand_key = randi() % 5
			$CharacterSound.stream = keys_sounds[rand_key]
			$CharacterSound.play()
		
	$NinePatchRect/Text.visible_characters = character_visible
