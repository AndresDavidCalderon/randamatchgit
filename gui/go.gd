extends aligner


onready var loader=ResourceLoader.load_interactive("res://forall/main.tscn")
func _ready():
	$start.visible=false
	set_process(false)
	worldman.connect("mustgo",self,"start")
	server.connect("updated",self,"servupd")
func servupd(type:String):
	if type=="servercreated":
		$start.visible=true
func _process(_delta):
	var error=loader.poll()
	$load.value=math.getloadpercentage(loader)
	match error:
		OK:
			pass
		ERR_FILE_EOF:
			get_tree().change_scene_to(loader.get_resource())
		_:
			globals.popup("we couldnt load the game","an error ocurred while trying to show you your terrain")
			globals.popuper.connect("closed",self,"back")
remote func start():
	set_process(true)
	if server.type=="server":
		rpc("start")
func back():
	globals.camera.page(1)
