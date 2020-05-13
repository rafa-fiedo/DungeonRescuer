extends AnimationPlayer

var scene_change_time = 1

func _ready():
	pass

func scene_init():
	MusicController.play_init_scene()
	
func scene_end():
	MusicController.play_end_scene()
