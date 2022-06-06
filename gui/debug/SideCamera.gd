extends Camera

func _process(delta):
	translation=globals.playernd.translation
	translation.x-=23
	rotation.y=-PI/2
