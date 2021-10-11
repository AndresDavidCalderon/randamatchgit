extends KinematicBody
export(float) var forwardspeed
export(float) var backspeed
export(float) var turnspeed
func _ready():
	globals.connect("pausing",self,"pause")
	pause()
func pause():
	if globals.paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if not globals.paused:
		if event is InputEventMouseMotion:
			rotation.y-=sign(event.relative.x)*turnspeed*get_process_delta_time()*(abs(event.relative.x)/10)

func _process(_delta):
	if not globals.paused:
		if Input.is_action_pressed("forward"):
			var vec=Vector2(forwardspeed,0).rotated(rotation.y)
			move_and_slide(Vector3(vec.y,0,vec.x))
		elif Input.is_action_pressed("back"):
			var vec=Vector2(-backspeed,0).rotated(rotation.y)
			move_and_slide(Vector3(vec.y,0,vec.x))
