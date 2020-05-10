extends Position2D


var player = null

func _ready():
	pass
	
func _process(delta):
	if player == null:
		return
		
	
func go_to_this_pos(player):
	player.set_position_to_move(global_position)
