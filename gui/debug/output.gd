extends Button
var valname:String
var value
export(String) var savename
var block:Panel
export(NodePath) var toblock
class_name output,"res://gui/debug/output.png"
signal needsfill
func _ready():
	if toblock!=null and toblock!="" and block==null:
		block=get_node(toblock)
	block.outputbyname[savename]=self
	globals.console.connect("executed",self,"execd")
func _pressed():
	if globals.console.selectedin==null:
		globals.console.selectedout=self
	else:
		globals.console.selectedin.setout(self)
		globals.console.selectedin=null
		globals.console.selectedout=null
func execd():
	value=null
