extends Path2D

export(float) var speed = 16

func _ready():
	pass

func _physics_process(delta):
	$PathFollow2D.offset += delta * speed
