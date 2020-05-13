extends Camera2D



func _ready():
	pass

func _process(delta):
	if offset.length() == 0:
		return
		
	if offset.length() < 0.5:
		offset = Vector2(0, 0)
		return
	
	offset = offset.normalized() * (offset.length() - (delta * 16))

func shake_it(vector):
	offset = vector
