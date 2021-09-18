extends RigidBody
# Declare member variables here. Examples:
export(float) var speed
export(float) var rotspeed
export(bool) var balancing
export(float) var rotgrav
export(float) var rotonair
onready var holder=get_node("/root/main/camholder")
onready var cam:ClippedCamera=get_node("/root/main/camholder/cam")
export(float) var goupspeed
onready var gen=get_node("/root/main/generator")
onready var initrot=rotation
onready var inittrans=translation
var hastokill=false
signal kill
signal onfis(state)
func kill():
	hastokill=true
	sleeping=true
	emit_signal("kill")
var ruedarot=0
# Called when the node enters the scene tree for the first time.
func _process(_delta):
	cam.get_node("sidertl/fps").text="fps: "+str(Engine.get_frames_per_second())
	get_node("/root/main/camholder/cam/sidertl/rot").text="rot="+str(rotation_degrees)
var tocallonint=[]
var tocallonintargs=[]
func callonint(funct:String,args:Array):
	tocallonint.resize(tocallonint.size()+1)
	tocallonintargs.resize(tocallonintargs.size()+1)
	tocallonint[tocallonint.size()-1]=funct
	tocallonintargs[tocallonintargs.size()-1]=args
export(bool) var reportbalancing
func _integrate_forces(state):
	var done=0
	while done<tocallonint.size():
		callv(tocallonint[done],tocallonintargs[done])
		done+=1
	tocallonint=[]
	tocallonintargs=[]
	emit_signal("onfis",state)
	var actspeed=speed
	if $getflor.get_overlapping_bodies().size()<1:
		actspeed=speed/4
		if Input.is_action_pressed("changedirl"):
			addlocaltorque("z",rotonair)
		elif Input.is_action_pressed("changedirr"):
			addlocaltorque("z",-rotonair)
		if Input.is_action_pressed("forward"):
			addlocaltorque("x",-rotonair)
		elif Input.is_action_pressed("brake"):
			addlocaltorque("x",rotonair)
	if hastokill:
		state.transform.origin=inittrans
		translation=inittrans
		rotation=initrot
		state.transform.basis=Basis(initrot)
		state.linear_velocity=Vector3()
		state.angular_velocity=Vector3()
		sleeping=false
		hastokill=false
	if Input.is_action_pressed("forward"):
		var go=tospatial(actspeed,rotation.y)
		if $getfront.get_overlapping_bodies().size()>0:
			if isleft():
				add_torque(Vector3(0,rotspeed,0))
			if isright():
				add_torque(Vector3(0,-rotspeed,0))
		add_central_force(Vector3(go.x,getvert(speed,rotation.x),go.y))
	if Input.is_action_pressed("brake"):
		var go=tospatial(-(actspeed/2),rotation.y)
		if $getfront.get_overlapping_bodies().size()>0:
			if isright():
				add_torque(Vector3(0,rotspeed,0))
			if isleft():
				add_torque(Vector3(0,-rotspeed,0))
		add_central_force(Vector3(go.x,-getvert(speed,rotation.x),go.y))
	#bajar o subir partes del carro, o gravedad angular. esto ya esta
	#en las fisicas normales, pero es necesario un empuje extra. ↓
	if balancing:
		if $getfront.get_overlapping_bodies().size()<1 and rotation.x>0:
			addlocaltorque("x",-rotgrav)
			if reportbalancing:
				print("lower front")
		if $getback.get_overlapping_bodies().size()<1 and rotation.x<0:
			addlocaltorque("x",rotgrav)
			if reportbalancing:
				print("lower back")
func tospatial(sp,dir):
	return Vector2(sp*-cos(dir+(PI*1.5)),sp*sin(dir+(PI*1.5)))
func getvert(sp,dir):
	var gety=0
	if $getflor.get_overlapping_bodies().size()>0:
		gety=sp*cos(dir-(PI/2))
	return gety
func isright():
	if Input.is_action_pressed("changedirr"):
		return true
	else:
		return false
func isleft():
	if Input.is_action_pressed("changedirl"):
		return true
	else:
		return false
var isripres=false
func _on_generator_generated():
	if server.type!="none" and server.players>1:
		var totalspace=gen.terrwide*30
		var partwide=totalspace/server.players
		var myspace=partwide*server.orderbyid[str(get_tree().get_network_unique_id())]
		translation.x=myspace-(totalspace/2)
	inittrans=translation
	initrot=rotation
	sleeping=false
	mode=MODE_RIGID
	$col.disabled=false
func addlocaltorque(axisarg:String,num:float):
	add_torque(get_indexed("transform:basis:"+axisarg)*num)
