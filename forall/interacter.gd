extends Area

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for i in get_overlapping_areas():
			if i.enabled:
				i.emit_signal("interacted")
