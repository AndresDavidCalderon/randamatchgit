extends aligner


func _on_back_pressed():
	globals.camera.page(1)
	server.kill()
