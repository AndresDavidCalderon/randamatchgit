extends Spatial

func _ready():
	globals.connect("debug_priority_changed",self,"set_visible")
	set_visible(globals.debug_prority)

func set_visible(enabled):
	for i in get_children():
		i.visible=enabled
