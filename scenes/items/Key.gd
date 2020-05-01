extends Area2D

signal item_raised

func _ready():
	pass

func _on_Key_body_entered(body):
	emit_signal("item_raised")
	
	$AnimationPlayer.play("Disappearing")
