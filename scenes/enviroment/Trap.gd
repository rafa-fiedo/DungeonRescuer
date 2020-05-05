extends Area2D


func _ready():
	pass

func turn_on_collisions():
	monitoring = true
	monitorable = true
	
func turn_off_collision():
	monitoring = false
	monitorable = false


func _on_Trap_body_entered(body):
	body.call_die()
