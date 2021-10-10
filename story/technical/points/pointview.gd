extends Viewport


func _ready():
	own_world=true
	$remotecam.fov=globals.camera.fov
	var error=get_parent().get_parent().connect("size_changed",self,"setsize")
	if error!=OK:
		globals.popuper.popup("error loading the world UI")
func setsize():
	if get_parent().get_parent() is Viewport:
		size=get_parent().get_parent().size
	else:
		globals.iprint("seems like the targetworld is in the wrong place")
