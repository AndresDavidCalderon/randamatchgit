extends TextureButton
func _on_picbutton_button_up():
	$frame.border_color.a=0.5

func _on_picbutton_button_down():
	$frame.border_color.a=1
	
