extends Area

export var speed:float
export var max_difference:float

func _ready():
	globals.connect("start",self,"on_start")
	globals.connect("end",self,"on_end")
	set_process(false)

func _process(delta):
	translation.y=globals.playernd.translation.y
	translation.x=globals.playernd.translation.x
	if globals.playernd.translation.z-max_difference>translation.z:
		translation.z=globals.playernd.translation.z-max_difference
	translation.z+=speed*delta

func on_start():
	$Timer.start()

func on_end():
	translation.z=-50
	set_process(false)

func _on_Timer_timeout():
	set_process(true)


func _on_Killer_body_entered(body):
	if body==globals.playernd:
		globals.playernd.kill()
