extends Node2D

var loader:ResourceInteractiveLoader
func _ready():
	set_process(false)
func _process(_delta):
	var error=loader.poll()
	match error:
		OK:
			if loader.get_stage()!=0:
				$bottom/load.value=math.getloadpercentage(loader)
		ERR_FILE_EOF:
			get_tree().change_scene_to(loader.get_resource())
func _on_picbutton_pressed():
	$bottom/load.visible=true
	loader=ResourceLoader.load_interactive(story.scnbymission["peterpan"])
	$picbutton.disabled=true
	set_process(true)
