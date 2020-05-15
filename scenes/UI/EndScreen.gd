extends Control


func _ready():
	pass


func _on_RichTextLabel_meta_clicked(meta):
	var err = OS.shell_open(meta)
	if err != OK:
		print(err)
