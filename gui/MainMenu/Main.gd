extends Control



func _on_Play_pressed():
	visible=false
	get_parent().get_node("OnMatch").visible=true
	globals.emit_signal("start")
