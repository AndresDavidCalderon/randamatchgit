extends RigidBody
class_name car,"res://classicons/player.png"
signal needsorders
export(float) var speed
export(float) var rotspeed
export(bool) var balancing
export(float) var balancing_force
export(float) var rotonair
export(float) var goupspeed
export(float) var vrotlimit
var byinput=false
onready var initrot=rotation
onready var inittrans=translation
var hastokill=false
signal kill
signal onfis(state)

func _init():
	globals.playernd=self

func kill():
	hastokill=true
	sleeping=true
	emit_signal("kill")

var ruedarot=0
var tocallonint=[]
var tocallonintargs=[]

#function to call on integrate forces
func callonint(funct:String,args:Array):
	tocallonint.resize(tocallonint.size()+1)
	tocallonintargs.resize(tocallonintargs.size()+1)
	tocallonint[tocallonint.size()-1]=funct
	tocallonintargs[tocallonintargs.size()-1]=args
var orders=[]

func _integrate_forces(state):
	var done=0
	orders=[]
	emit_signal("needsorders")
	while done<tocallonint.size():
		callv(tocallonint[done],tocallonintargs[done])
		done+=1
	tocallonint=[]
	tocallonintargs=[]
	emit_signal("onfis",state)
	
	#the speed affected by changing data
	var current_speed=speed
	var on_floor=$getflor.get_overlapping_bodies().size()>0
	if not on_floor:
		current_speed/=2
		if orders.has("l"):
			addlocaltorque("z",rotonair)
		elif orders.has("r"):
			addlocaltorque("z",-rotonair)
		if orders.has("accel"):
			addlocaltorque("x",-rotonair)
		elif orders.has("break"):
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
	
	if orders.has("accel"):
		var direction=get_rotated_vector(Vector3(0,0,-current_speed))
		if $getfront.get_overlapping_bodies().size()>0:
			if orders.has("left"):
				add_torque(Vector3(0,rotspeed,0))
			if orders.has("right"):
				add_torque(Vector3(0,-rotspeed,0))
		add_central_force(direction)
	
	if orders.has("break"):
		var direction=get_rotated_vector(Vector3(0,0,current_speed/2))
		if $getfront.get_overlapping_bodies().size()>0:
			if orders.has("right"):
				add_torque(Vector3(0,rotspeed,0))
			if orders.has("left"):
				add_torque(Vector3(0,-rotspeed,0))
		add_central_force(direction)
	
	if balancing:
		if $getfront.get_overlapping_bodies().size()<1 and rotation.x>0:
			addlocaltorque("x",-balancing_force)
		if $getback.get_overlapping_bodies().size()<1 and rotation.x<0:
			addlocaltorque("x",balancing_force)

func addlocaltorque(axisarg:String,num:float):
	add_torque(get_indexed("transform:basis:"+axisarg)*num)

func get_rotated_vector(vec:Vector3):
	var newvec:Vector3=vec
	newvec=newvec.rotated(Vector3(0,0,1),transform.basis.get_euler().z)
	newvec=newvec.rotated(Vector3(1,0,0),transform.basis.get_euler().x)
	newvec=newvec.rotated(Vector3(0,1,0),transform.basis.get_euler().y)
	return newvec
