extends Node
var closeonback=true
var fileman=File.new()
var dirs=Directory.new()
var savedir:String="user://randamatchuser.json"
var file:={
	"coins":0
}
signal filedone(file)
var loaded=false
func save():
	if dirs.file_exists(savedir):
		dirs.remove(savedir)
	fileman.open(savedir,File.WRITE)
	fileman.store_string(JSON.print(file))
	fileman.close()
	
func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			save()

func _ready():
	if fileman.file_exists(savedir):
		var openerror=fileman.open(savedir,File.READ)
		if openerror==OK:
			var result=JSON.parse(fileman.get_as_text()) as JSONParseResult
			if result.error==OK and typeof(result.result)==TYPE_DICTIONARY:
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
	fileman.close()
	emit_signal("filedone",file)
func waitforfile(who:Node,method="onfile"):
	if who.has_method(method):
		if loaded:
			who.call(method,file)
		else:
			connect("filedone",who,"onfile")
	else:
		globals.iprint("couldnt notify on file loading")
func tofolder():
	var error=OS.shell_open("file://"+savedir)
	if error!=OK:
		globals.popuper.popup("couldnt open the folder","error "+str(error))
func reset():
	file={}
func quiterror():
	get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)
