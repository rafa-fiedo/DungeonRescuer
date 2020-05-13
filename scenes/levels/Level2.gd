extends Node2D

export(PackedScene) var enemy_orc_scene = null

func _ready():
	MusicController.play_background()
	SceneTranslator.play("InitOfScene")
	if Global.player_data:
		$Player.load_data(Global.player_data)
		

func _on_timer_timeout():
	var enemy = enemy_orc_scene.instance()
	enemy.position = $OrcPosition.global_position
	add_child(enemy)

func _on_Switch_switched_on():
	$AnimationPlayer.play("door_unlock")
	
	var timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(0.6)
	timer.autostart = true
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timer_timeout")
	get_tree().current_scene.add_child(timer)
	

func _on_Checkpoint_body_entered(body):
	Global.player_data = body.get_save_data()
