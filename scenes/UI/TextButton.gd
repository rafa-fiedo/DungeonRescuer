extends RichTextLabel

signal pressed 


func _ready():
	pass

func _on_StartGame_pressed():
	emit_signal("pressed")
