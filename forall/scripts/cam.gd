extends ClippedCamera
func _process(_delta):
	$sidertl/fps.text="fps:"+str(Performance.get_monitor(Performance.TIME_FPS))
