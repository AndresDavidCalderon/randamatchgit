extends Viewport


func _ready():
	own_world=true
	$remotecam.fov=globals.camera.fov
	var error=get_parent().get_parent().connect("size_changed",self,"setsize")
	if error!=OK:
		globals.popuper.popup("error loading the world UI")
func setsize():
	size=get_parent().get_parent().size
