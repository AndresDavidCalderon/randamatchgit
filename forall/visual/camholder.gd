tool
extends Spatial
export(Vector3) var baserot
export(float) var cameradistance=10 setget camdist
export(float) var cameraangle setget camangle
export(Vector3) var offset setget setoff
export(NodePath) var totarget
var target:Spatial
func _process(_delta):
	if target!=null:
		translation=target.global_transform.origin
		rotation=Vector3()
		rotation.y=target.rotation.y
		rotation+=baserot
	else:
		target=get_node(totarget)

func camdist(value):
	cameradistance=value
	updatethird()
func setoff(value):
	offset=value
	updatethird()

func camangle(value):
	cameraangle=value
	updatethird()

func updatethird():
	if get_node("cam")!=null:
		var vec=Vector2(cameradistance,0).rotated(cameraangle)
		$cam.translation.z=vec.x
		$cam.translation.y=vec.y
		$cam.translation.x=0
		$cam.translation+=offset
		$cam.rotation.x=vec.angle()+PI
		$cam.rotation.y=PI
	
