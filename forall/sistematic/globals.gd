extends Node2D
var console:Node2D
var res:resman
var camera
var ostype:String
var popuper:Panel
var UIscale
var playernd:player
export(Dictionary) var consoleshorts
onready var defres=Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))
func _init():
	match OS.get_name():
		"Android","iOS":
			ostype="mobile"
		"Windows","OSX","HTML5","UWP":
			ostype="desktop"
func iprint(text):
	if console==null or Engine.editor_hint:
			prints(text)
	else:
		if text is Array:
			console.printsline(text)
		else:
			console.printsline([text])
func getguisize():
	var vews=get_viewport_rect().size/defres
	if vews.x>vews.y:
		return Vector2(vews.y,vews.y)
	else:
		return Vector2(vews.x,vews.x)
