extends ViewportContainer

func _ready():
	visible=false

func _input(event):
	if event.is_action_pressed("ExtraView"):
		visible=not visible
