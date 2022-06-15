extends CanvasLayer

export(Array,NodePath) var screens

func _ready():
	globals.connect("end",self,"set_screen",[0])
	set_screen(0)

func set_screen(idx:int):
	for i in screens.size():
		get_node(screens[i]).visible=i==idx
