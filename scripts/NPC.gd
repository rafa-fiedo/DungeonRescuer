extends Node2D

export(bool) var is_start_left = true
export(bool) var deactivate = false

var body_inside = null
var is_dialog_on = false
var current_dialogue_node_name = "DialoguePlayer"
var last_flip = is_start_left

func _ready():
	if has_node("Sprite"):
		$Sprite.flip_h = is_start_left
		
	if has_node("Character"):
		$Character/Sprite.flip_h = is_start_left
		
	$CollisionShape2D.disabled = deactivate
	
	set_process_input(!deactivate)
	set_process(!deactivate)
	
	# connecting signals 
	for child in get_children():
		if "DialoguePlayer" in child.name:
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

func turn_to_player(player_node):
	if has_node("Sprite"):
		last_flip = $Sprite.flip_h 
		$Sprite.flip_h = true if player_node.global_position.x < global_position.x else false
	
	if has_node("Character"):
		last_flip = $Character/Sprite.flip_h 
		$Character/Sprite.flip_h = true if player_node.global_position.x < global_position.x else false

func play_animation(animation):
	if has_node("Sprite"):
		pass
		
	if has_node("Character"):
		$Character.play_animation(animation)

func reset_flip():
	if has_node("Sprite"):
		$Sprite.flip_h = last_flip
		
	if has_node("Character"):
		$Character/Sprite.flip_h = last_flip

func turn_around():
	if has_node("Sprite"):
		$Sprite.flip_h = !$Sprite.flip_h
		
	if has_node("Character"):
		$Character/Sprite.flip_h = !$Character/Sprite.flip_h

func activate():
	call_deferred("active_deferred")
	set_process_input(true)
	set_process(true)
	visible = true
	
func deactivate_it():
	call_deferred("active_deferred2")
	set_process_input(false)
	set_process(false)
	visible = true
	
func active_deferred():
	$CollisionShape2D.disabled = false
	
func active_deferred2():
	$CollisionShape2D.disabled = true
	
# TODO refactor and delete it because last wife is using it after game over
func load_scene_after_black():
	pass

