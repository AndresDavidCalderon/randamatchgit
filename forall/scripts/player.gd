extends RigidBody
class_name car,"res://classicons/player.png"
signal needsorders
export(float) var speed
export(float) var rotspeed
export(bool) var balancing
export(float) var rotgrav
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
	var actspeed=speed
	if $getflor.get_overlapping_bodies().size()<1:
		actspeed=speed/4
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
		var go=tospatial(actspeed,rotation.y)
		if $getfront.get_overlapping_bodies().size()>0:
			if orders.has("left"):
				add_torque(Vector3(0,rotspeed,0))
			if orders.has("right"):
				add_torque(Vector3(0,-rotspeed,0))
		add_central_force(Vector3(go.x,getvert(speed,rotation.x),go.y))
	if orders.has("break"):
		var go=tospatial(-(actspeed/2),rotation.y)
		if $getfront.get_overlapping_bodies().size()>0:
			if orders.has("right"):
				add_torque(Vector3(0,rotspeed,0))
			if orders.has("left"):
				add_torque(Vector3(0,-rotspeed,0))
		add_central_force(Vector3(go.x,0,go.y))
	#bajar o subir partes del carro, o gravedad angular. esto ya esta
	#en las fisicas normales, pero es necesario un empuje extra. ↓
	if balancing:
		if $getfront.get_overlapping_bodies().size()<1 and rotation.x>0:
			addlocaltorque("x",-rotgrav)
		if $getback.get_overlapping_bodies().size()<1 and rotation.x<0:
			addlocaltorque("x",rotgrav)
func tospatial(sp,dir):
	return Vector2(sp*-cos(dir+(PI*1.5)),sp*sin(dir+(PI*1.5)))
func getvert(sp,dir):
	var gety=0
	if $getflor.get_overlapping_bodies().size()>0:
		gety=sp*cos(dir-(PI/2))
	return gety
var isripres=false
func addlocaltorque(axisarg:String,num:float):
	add_torque(get_indexed("transform:basis:"+axisarg)*num)
