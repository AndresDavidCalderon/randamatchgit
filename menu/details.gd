extends aligner
var gui:String setget setsec
var node:Node2D
func setsec(value):
	if node!=null:
		node.visible=false
	gui=value
	node=get_node(gui)
	node.visible=true
func _ready():
	var error=get_viewport().connect("size_changed",self,"setsize")
	if error!=OK:
		globals.popuper.popup("couldnt get window resize signal","you might see some errors")
func setsize():
	$back.rect_size.y=get_viewport_rect().size.y*math.getantiscale(scale.y)
