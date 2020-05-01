extends StaticBody2D


func _ready():
	pass


func _on_VisibilityNotifier2D_screen_entered():
	$CollisionShape2D.disabled = false


func _on_VisibilityNotifier2D_screen_exited():
	$CollisionShape2D.disabled = true
