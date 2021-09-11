extends Button
onready var label=get_parent().get_node("name")
var editer:LineEdit
func _ready():
	saver.waitforfile(self)
func _pressed():
	askforname()
func onfile(file:Dictionary):
	if file.has("name"):
		label.text=file["name"]
func start():
	if saver.file.has("name"):
		label.text=saver.file["name"]
		return true
	else:
		askforname()
		return false
func setname():
	saver.file["name"]=editer.text
	globals.popuper.unpopup()
	start()
func askforname():
	var button=globals.popuper.popup("set your name","",[LineEdit,Button])
	button[1].text="go"
	button[1].connect("pressed",self,"setname")
	editer=button[0]
