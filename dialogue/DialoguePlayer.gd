extends Node

export(PackedScene) var dialogue_ui
export(String, FILE, "*.json") var dialogue_file

var dialogue_ui_node = null # init in the start_dialogue and destroy later
# json have array of dialogues, if there is more than one, 
# the next will be played and so on
var current_dialogue_id = 0 
var dialogue_keys = []
var current_line_id = 0

var is_last_dialogue = false
var is_dialog_working = false

signal dialogue_started
signal dialogue_finished
signal last_dialogue_finished



func start_dialogue():
	emit_signal("dialogue_started")
	is_dialog_working = true
	current_line_id = 0
	index_dialogue()
	
	if get_parent().has_method("turn_to_player"):
		var player_node = get_tree().current_scene.find_node("Player")
		if player_node:
			get_parent().turn_to_player(player_node)

			
	
	dialogue_ui_node = dialogue_ui.instance()
	add_child(dialogue_ui_node)
	 # <source_node>.connect(<signal_name>, <target_node>, <target_function_name>)
	dialogue_ui_node.connect("next_dialogue", self, "next_dialogue")
	dialogue_ui_node.show_dialogue(dialogue_keys[current_line_id].text)
	
func next_dialogue():
	current_line_id += 1
	if current_line_id == dialogue_keys.size():
		dialogue_ui_node.queue_free()
			
		emit_signal("dialogue_finished")
		if is_last_dialogue:
			emit_signal("last_dialogue_finished")
		
		is_dialog_working = false
		
		if get_parent().has_method("reset_flip"):
			get_parent().reset_flip()
			
		return
		
	# defender for fast clickers
	if current_line_id >= dialogue_keys.size():
		return
		
	dialogue_ui_node.show_dialogue(dialogue_keys[current_line_id].text)

func index_dialogue():
	var dialogues = load_dialogue()
	if current_dialogue_id >= len(dialogues):
		current_dialogue_id = len(dialogues) - 1
	dialogue_keys = dialogues[current_dialogue_id]
	current_dialogue_id += 1
	if current_dialogue_id == len(dialogues):
		is_last_dialogue = true
		
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
