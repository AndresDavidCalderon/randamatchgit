extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var byinput=false
export var directs=false
export var accels=true
export (float) var dirotmax=5
export(String,"global","local") var rotmode
export(float) var direffectspeed=2
export(float) var dirotresist=4
export(float) var initimpulse=6
export(float) var impulsespeed=2
export(float) var impulseresist=0.7
var impulse=0
var getback=false
var dirot=0
var getbackimp=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if byinput:
		if Input.is_action_pressed("changedirl"):
			addtorq(1)
		elif Input.is_action_pressed("changedirr"):
			addtorq(-1)
		if Input.is_action_pressed("forward"):
			addimpulse(-1)
		elif Input.is_action_pressed("brake"):
			addimpulse(1)
	if directs:
		var baseangle:float
		if rotmode=="local":
			baseangle=rotation_degrees.x
		else:
			baseangle=(global_transform.basis.get_euler()-get_parent().global_transform.basis.get_euler()).x
		if abs(dirot)>dirotresist*delta:
			if abs(baseangle)-abs(dirot)>direffectspeed or sign(baseangle)!=sign(dirot):
				if rotation_degrees.x>dirot:
					changeanglex(baseangle-direffectspeed)
				else:
					changeanglex(baseangle+direffectspeed)
			else:
				changeanglex(dirot)
			if getback:
				dirot+=(dirotresist*delta)*-sign(dirot)
		else:
			dirot=0
			changeanglex(0)
	if accels:
		if abs(impulse)>impulseresist:
			rotation.y-=(impulsespeed*delta)*sign(impulse)
			if getbackimp:
				impulse+=impulseresist*-sign(impulse)
		else:
			impulse=0
func addtorq(simbol:int):
	if (abs(dirot)<abs(dirotmax)) or sign(dirot)!=sign(simbol):
		dirot=dirotmax*sign(simbol)
		$getback.start($getback.wait_time)
func addimpulse(simbol:int):
	impulse=initimpulse*sign(simbol)
	getbackimp=false
	$getbackimp.start($getbackimp.wait_time)
func changeanglex(angle:float):
	if rotmode=="local":
		rotation_degrees.x=angle
	else:
		var parrot=get_parent().global_transform.basis.get_euler()
		var movevec=Vector3(parrot.x+1,parrot.y,parrot.x).normalized()
		global_rotate(movevec,deg2rad(angle))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_getback_timeout():
	getback=true


func _on_getbackimp_timeout():
	getbackimp=true
