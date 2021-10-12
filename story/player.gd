extends KinematicBody
export(float) var forwardspeed=23
export(float) var backspeed=10
export(float) var turnspeed
export(float) var sidespeed=10
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
			moveonsurface(Vector2(forwardspeed,0))
		if Input.is_action_pressed("back"):
			moveonsurface(Vector2(-backspeed,0))
		if Input.is_action_pressed("right"):
			moveonsurface(Vector2(0,-sidespeed))
		if Input.is_action_pressed("left"):
			moveonsurface(Vector2(0,sidespeed))
func moveonsurface(vec:Vector2):
	vec=vec.rotated(rotation.y)
	if Input.is_action_pressed("sprint"):
		vec*=1.5
	move_and_slide(Vector3(vec.y,0,vec.x),Vector3(),false,4,0.78,false)
