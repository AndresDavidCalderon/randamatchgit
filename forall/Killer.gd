extends Area

export var speed:float
export var max_difference:float

func _ready():
	set_process(false)

func _process(delta):
	translation.y=globals.playernd.translation.y
	translation.x=globals.playernd.translation.x
	if globals.playernd.translation.z-max_difference>translation.z:
		translation.z=globals.playernd.translation.z-max_difference
	translation.z+=speed*delta


func _on_Timer_timeout():
	set_process(true)
