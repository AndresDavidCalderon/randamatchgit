extends Button
var valname:String
var value
var index:int
var block:Panel
var target:Button
export(NodePath) var toblock=".."
class_name input,"res://gui/debug/input.png"
export(String) var savename
func _ready():
	if toblock!=null and toblock!="" and block==null:
		block=get_node(toblock)
	index=block.inputs.size()
	block.inputs.append(self)
	set_process(false)
	globals.console.connect("visibility_changed",self,"consolevis")
func _process(_delta):
	syncline()
func _pressed():
	if globals.console.selectedout==null:
		globals.console.selectedin=self
	else:
		setout(globals.console.selectedout)
		globals.console.selectedin=null
		globals.console.selectedout=null
		set_process(true)
func setout(with:Button):
	if block!=with.block:
		target=with
		syncline()
		set_process(true)
	else:
		globals.console.printsline(["you cant connect stuff in the same block"])
func syncline():
	$line.set_as_toplevel(true)
	$line.points[0]=rect_global_position+(rect_size/2*rect_scale)
	$line.points[1]=target.rect_global_position+(target.rect_size/2*target.rect_scale)
func consolevis():
	$line.visible=globals.console.visible
	if target!=null:
		set_process(globals.console.visible)
