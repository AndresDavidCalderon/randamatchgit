extends KinematicBody
export(float) var forwardspeed
export(float) var backspeed
func _process(_delta):
	if not globals.paused:
		if Input.is_action_pressed("forward"):
			var vec=Vector2(forwardspeed,0).rotated(rotation.y)
			move_and_slide(Vector3(0,vec.y,vec.x))
		elif Input.is_action_pressed("back"):
			var vec=Vector2(-backspeed,0).rotated(rotation.y)
			move_and_slide(Vector3(0,vec.y,vec.x))
		Input.warp_mouse_position(globals.camera.get_node("center").position)
