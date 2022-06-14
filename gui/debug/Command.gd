extends LineEdit

func _ready():
	visible=globals.debug_prority
	globals.connect("debug_priority_changed",self,"set_visibility")

func set_visibility(enabled):
	visible=enabled
	
func _on_Command_text_entered(new_text):
	text=""
	release_focus()
	match new_text:
		"stopit":
			get_node("/root/main/Killer").speed=0
		
