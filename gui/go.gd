extends aligner


onready var loader=ResourceLoader.load_interactive("res://forall/main.tscn")
func _ready():
	set_process(false)
func _process(_delta):
	var error=loader.poll()
	$load.value=loader.get_stage_count()/loader.get_stage()
	match error:
		OK:
			pass
		ERR_FILE_EOF:
			get_tree().change_scene_to(loader.get_resource())
		_:
			globals.iprint("error loading")
func _on_start_pressed():
	set_process(true)
