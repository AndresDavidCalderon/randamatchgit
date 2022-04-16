extends Node2D
class_name aligner,"res://gui/images/extendericon.png"
export(bool) var bottom
export(bool) var right
export var scaleview=Vector2(1,1)
export(bool) var invisiblestart
export(Vector2) var offset
onready var initscale=scale
export(bool) var scalesondesktop
export(bool) var scalesonmobile=true
export(bool) var fromzero=true
func _ready():
	if invisiblestart:
		visible=false
	var error=get_tree().root.connect("size_changed", self, "setgui")
	if error!=OK:
		globals.popuper.popup("the UI couldnt load correctly")
	setgui()
func setgui():
	var base=get_viewport_rect()
	if fromzero:
		position=Vector2(0,0)
	if bottom:
		position.y=base.size.y*scaleview.y
	if right:
		position.x=base.size.x*scaleview.x
	position+=offset
