extends Control



func _on_Play_pressed():
	globals.emit_signal("start")
