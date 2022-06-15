extends RigidBody
class_name car,"res://Player/player.png"
signal needsorders
export(float) var speed
export(float) var rotspeed
export(bool) var balancing
export(float) var balancing_force
export(float) var rotonair
export(float) var jump_force
export var impulse_offset:Vector3

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
	if not globals.on_match: return
	
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
	
	if $getfront.get_overlapping_bodies().size()==0 or $getback.get_overlapping_bodies().size()==0:
		current_speed/=2
		if orders.has("accel"):
			addlocaltorque("x",-rotonair)
		elif orders.has("brake"):
			addlocaltorque("x",rotonair*5)
	
	if $GetRight.get_overlapping_bodies().size()==0 or $GetLeft.get_overlapping_bodies().size()==0:
		
		if ($GetRight.get_overlapping_bodies().size()==0)!=($GetLeft.get_overlapping_bodies().size()==0):
			if orders.has("r"):
				addlocaltorque("z",-rotonair*2.5)
			elif orders.has("l"):
				addlocaltorque("z",rotonair*2.5)
		else:
			if orders.has("l"):
				addlocaltorque("z",rotonair*1.5)
			elif orders.has("r"):
				addlocaltorque("z",-rotonair*1.5)
		
	if hastokill:
		state.transform.origin=inittrans
		translation=inittrans
		rotation=initrot
		state.transform.basis=Basis(initrot)
		state.linear_velocity=Vector3()
		state.angular_velocity=Vector3()
		sleeping=false
		hastokill=false
		globals.emit_signal("end")
	
	if orders.has("accel"):
		if $getfront.get_overlapping_bodies().size()>0:
			if orders.has("left"):
				add_torque(Vector3(0,rotspeed,0))
			if orders.has("right"):
				add_torque(Vector3(0,-rotspeed,0))
		
		var direction=get_rotated_vector(Vector3(0,0,-current_speed))
		add_force(direction,get_rotated_vector(impulse_offset))
		$Debug/ThrottlePoint.translation=direction
	
	if orders.has("brake"):
		if $getfront.get_overlapping_bodies().size()>0:
			if orders.has("right"):
				add_torque(Vector3(0,rotspeed,0))
			if orders.has("left"):
				add_torque(Vector3(0,-rotspeed,0))
		var direction=get_rotated_vector(Vector3(0,0,current_speed))
		var offset=get_rotated_vector(Vector3(0,3,0),Vector3(PI,0,0))
		add_force(direction,offset)
		$Debug/BrakePoint.translation=direction
		$Debug/BrakeOffset.translation=offset
		
	
	if balancing:
		if $getfront.get_overlapping_bodies().size()<1 and rotation.x>0:
			addlocaltorque("x",-balancing_force)
		if $getback.get_overlapping_bodies().size()<1 and rotation.x<0:
			addlocaltorque("x",balancing_force)


func addlocaltorque(axisarg:String,num:float):
	var rot=get_indexed("transform:basis:"+axisarg)*num
	
	add_torque(rot)
func apply_local_torque_impulse(axisarg:String,num:float):
	apply_torque_impulse(get_indexed("transform:basis:"+axisarg)*num)

func get_rotated_vector(vec:Vector3,offset:Vector3=Vector3(0,0,0)):
	var newvec:Vector3=vec
	newvec=newvec.rotated(Vector3(0,0,1),transform.basis.get_euler().z+offset.x)
	newvec=newvec.rotated(Vector3(1,0,0),transform.basis.get_euler().x+offset.y)
	newvec=newvec.rotated(Vector3(0,1,0),transform.basis.get_euler().y+offset.z)
	return newvec
