extends Path2D

export(float) var walk_speed_npc = 32

var npc_walking = false

signal path_ended

func _ready():
	$PathFollow2D.unit_offset = 0
	
func _process(delta):
	if npc_walking:
		$PathFollow2D.offset += delta * walk_speed_npc
		$PathFollow2D/NPC_First.play_animation("Run")
		
		if($PathFollow2D.unit_offset >= 1):
			emit_signal("path_ended")
			npc_walking = false
			$PathFollow2D/NPC_First.play_animation("Idle")

func start_path():
	npc_walking = true
	
