extends TextureButton
func _on_picbutton_button_up():
	$frame.modulate.a=1

func _on_picbutton_button_down():
	$frame.modulate.a=0.5
