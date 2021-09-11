extends aligner


onready var loader=ResourceLoader.load_interactive("res://forall/main.tscn")
func _ready():
	set_process(false)
func _process(_delta):
	var error=loader.poll()
	$load.value=(float(loader.get_stage())/float(loader.get_stage_count()))*100
	match error:
		OK:
			pass
		ERR_FILE_EOF:
			get_tree().change_scene_to(loader.get_resource())
		_:
			var buts=globals.popup("we couldnt load the game","an error ocurred while trying to show you your terrain")
			globals.popuper.connect("closed",self,"back")
func _on_start_pressed():
	set_process(true)
func back():
	globals.camera.page(1)
