extends KinematicBody2D

var body_inside = null
var is_dialog_on = false
var current_dialogue_node_name = "DialoguePlayer"

func _ready():
	for child in get_children():
		if child.name.match("DialoguePlayer"):
			child.connect("dialogue_started", self, "start_dialogue")
			child.connect("dialogue_finished", self, "finish_dialogue")

func start_dialogue():
	if body_inside:
		is_dialog_on = true
		body_inside.set_active(false)
	
func finish_dialogue():
	is_dialog_on = false
	if body_inside:
		body_inside.set_active(true)


func _on_PlayerDetector_body_entered(body):
	body_inside = body

func _on_PlayerDetector_body_exited(body):
	body.set_active(true)
	body_inside = null
	
func _process(_delta):
	if !body_inside:
		return
	if is_dialog_on:
		return 
		
	if Input.is_action_just_pressed("game_use"):
		var dialogue_node = get_node_or_null(current_dialogue_node_name)
		if dialogue_node:
			dialogue_node.start_dialogue()
		else:
			print("No dialogue node in this NPC")
