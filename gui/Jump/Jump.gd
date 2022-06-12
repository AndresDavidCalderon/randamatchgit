extends TouchScreenButton

func _process(delta):
	visible=globals.playernd.get_node("getflor").get_overlapping_bodies().size()>0 and $CoolDown.time_left==0
	get_parent().get_node("BottomRight/JumpProgress").value=100*$CoolDown.time_left/$CoolDown.wait_time

func _on_Jump_pressed():
	$CoolDown.start()
