extends AudioStreamPlayer2D

var fire_fire_sound = load("res://resources/audio/sound_effects/spells/fire_fire.wav")
var fire_loading_sound = load("res://resources/audio/sound_effects/spells/fire_loading.wav")

func _ready():
	pass

func fire_fire():
	stream = fire_fire_sound
	play()
	
func fire_loading():
	if stream == fire_loading_sound:
		return
	stream = fire_loading_sound
	play()
	
