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
onready var defres=Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))
var scales=false
func _ready():
	if invisiblestart:
		visible=false
	get_tree().root.connect("size_changed", self, "setgui")
	setgui()
	if (scalesondesktop and (OS.get_name()=="Windows" or OS.get_name()=="OSX" or OS.get_name()=="WUP")) or (scalesonmobile and (OS.get_name()=="Android" or OS.get_name()=="iOS")):
		scales=true
func setgui():
	var base=get_viewport_rect()
	position=Vector2(0,0)
	if bottom:
		position.y=base.size.y*scaleview.y
	if right:
		position.x=base.size.x*scaleview.x
	position+=offset
	if scales:
		var vews=get_viewport_rect().size/defres
		var minvews
		if vews.x>vews.y:
			minvews=vews.y
		else:
			minvews=vews.x
		scale=initscale*(minvews)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
