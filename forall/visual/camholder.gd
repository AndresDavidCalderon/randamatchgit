tool
extends Spatial
export(Vector3) var baserot
export(bool) var active
export(float) var cameradistance=10 setget camdist
export(float) var cameraangle setget camangle
export(float) var turnspeed=0.15
export var managemouse:bool=true
export(Vector3) var offset setget setoff
export(NodePath) var totarget
var target:Spatial
func _process(_delta):
	if active:
		if target!=null:
			translation=target.global_transform.origin
			rotation=Vector3()
			rotation.y=target.rotation.y
			if Engine.editor_hint:return
			rotation+=math.vectorad(baserot)
		else:
			target=get_node(totarget)
func _ready():
	globals.connect("pausing",self,"pause")
	pause()
func pause():
	if managemouse:
		if globals.paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if managemouse and not globals.paused:
		if event is InputEventMouseMotion:
			baserot.y-=sign(event.relative.x)*turnspeed

func camdist(value):
	cameradistance=value
	updatethird()
func setoff(value):
	offset=value
	updatethird()

func camangle(value):
	cameraangle=value
	updatethird()
export var addpi:bool
func updatethird():
	if is_inside_tree() and get_node("cam")!=null:
		var vec=Vector2(cameradistance,0).rotated(cameraangle)
		$cam.translation.z=vec.x
		$cam.translation.y=vec.y
		$cam.translation.x=0
		$cam.translation+=offset
		$cam.rotation.x=vec.angle()+(PI*int(addpi))
		$cam.rotation.y=PI
	
