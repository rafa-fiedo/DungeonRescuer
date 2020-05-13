extends StaticBody2D

enum BoxFilling {Potion, Empty, Key} # count matters

var potion_dialogue = "res://dialogue/dialogue_data/level_5/box_potion.json"
var empty_dialogue = "res://dialogue/dialogue_data/level_5/box_empty.json"
var key_dialogue = "res://dialogue/dialogue_data/level_5/box_key.json"

signal box_opened

var is_opened = false

func _ready():
	pass
	
func _input(event):
	if is_opened:
		return
	if event.is_action_pressed("game_use") && len($PlayerDetector.get_overlapping_bodies()) > 0:
		emit_signal("box_opened", $".")
		is_opened = true
		
func _on_SoundTimer_timeout():
	$Sound.play()
		
func open_box(box_filling):
	if box_filling == BoxFilling.Key:
		$AnimationPlayer.play("BoxKey")
		$DialoguePlayer.dialogue_file = key_dialogue
	elif box_filling == BoxFilling.Potion:
		$AnimationPlayer.play("BoxPotion")
		$DialoguePlayer.dialogue_file = potion_dialogue
	else:
		$AnimationPlayer.play("BoxEmpty")
		$DialoguePlayer.dialogue_file = empty_dialogue
	
	$SoundTimer.start(0.1)
		
	$DialoguePlayer.start_dialogue()
