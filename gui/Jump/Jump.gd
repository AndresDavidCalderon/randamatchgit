extends TouchScreenButton

func _process(_delta):
	visible=globals.playernd.get_node("getflor").get_overlapping_bodies().size()>0 and $CoolDown.time_left==0
	get_parent().get_node("JumpProgress").value=100-100*$CoolDown.time_left/$CoolDown.wait_time

func _on_Jump_pressed():
	$CoolDown.start()
	yield(globals.playernd,"onfis")
	globals.playernd.apply_central_impulse(globals.playernd.get_rotated_vector(Vector3(0,globals.playernd.jump_force,0)))

func _ready():
	globals.connect("start",self,"on_start")

func on_start():
	$CoolDown.stop()
