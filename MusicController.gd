extends Node

# Backgorund music
var background_music = load("res://resources/audio/music/2020_05 Dungeon Backgroud.ogg")

# Battle Music
var battle_music = load("res://resources/audio/music/2020_05 Dungeon Fighter loop 14_6.ogg")

# Victories Music
var victory_music = load("res://resources/audio/music/Dungeon Victory.ogg")

var mute = false

func _ready():
	pass

func play_background():
	if mute:
		return
		
	if $Music.stream == background_music and $Music.playing:
		return
	
	$Music.stream = background_music
	$Music.play()

func play_battle():
	if mute:
		return
	$Music.stream = battle_music
	$Music.play()
	
func play_victory():
	if mute:
		return
	$Music.stream = victory_music
	$Music.play()

func play_init_scene():
	$AnimationPlayer.play("SceneInit")
	
func play_end_scene():
	$AnimationPlayer.play("SceneEnd")

func stop():
	$Music.stop()
