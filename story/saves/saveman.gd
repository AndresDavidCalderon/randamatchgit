extends Node
var fileman=File.new()
var dirs=Directory.new()
var savedir:String="user://randamatchuser.json"
var file:Dictionary
signal filedone(file)
var loaded=false
func ready():
	var openerror=fileman.open(savedir,File.WRITE_READ)
	if openerror==OK:
		var result=JSON.parse_json(fileman.get_as_text()) as JSONParseResult
		if result.error!=OK:
			file=result.result
		else:
			file={}
			globals.popuper.popup("error getting your file",str(result.error)+" on line "+str(result.error_line))
	else:
		var buttons=globals.popuper.popup("error loading your file","you may want to close the game and see whats wrong ¿maybe you have a backup?",[Button,Button,Button]) as Array
		buttons[0].text="open save folder"
		buttons[0].connect("pressed",self,"tofolder")
		buttons[1].text="continue without progress"
		buttons[1].connect("pressed",self,"reset")
		buttons[2].text="quit"
		buttons[1].connect("pressed",self,"quiterror")
	loaded=true
	emit_signal("filedone",file)
func waitforfile(who:Node,method="onfile"):
	if loaded:
		who.call(method,file)
	else:
		who.connect("filedone",who,"onfile")
func tofolder():
	OS.shell_open("file://"+savedir)
func reset():
	file={}
func quiterror():
	get_tree().quit()
