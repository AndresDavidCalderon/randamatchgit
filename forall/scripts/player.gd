extends Spatial
class_name car,"res://Player/player.png"
signal needsorders
export(float) var acceleration
#max speed is set on the joint scene

export(float) var rotspeed
export(bool) var balancing
export(float) var balancing_force
export(float) var rotonair
export(float) var jump_force

export var dir_rotation_speed:float
export var dir_rot_limit:float

#rotation added through add_torque and not through the wheels.
export var magical_rotation:float

export var impulse_treshold:float
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
	emit_signal("kill")
	

func _input(event):
	if event.is_action_pressed("up_jump"):
		translation.y+=40

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

var last_direction:int=0

func _integrate_forces():
	var done=0
	orders={}
	emit_signal("needsorders")
	while done<tocallonint.size():
		callv(tocallonint[done],tocallonintargs[done])
		done+=1
	tocallonint=[]
	tocallonintargs=[]
	#the speed affected by changing data
	var current_acceleration=acceleration
	
	if $FrontWheel/FrontFloor.get_overlapping_bodies().size()==0 or $BackWheel/BackFloor.get_overlapping_bodies().size()==0:
		current_acceleration/=2
		if orders["front"]>0:
			$CarBody.addlocaltorque("x",-rotonair*orders["front"])
		elif orders["front"]<0:
			$CarBody.addlocaltorque("x",rotonair*5*orders["front"])
	
	if $GetRight.get_overlapping_bodies().size()==0 or $GetLeft.get_overlapping_bodies().size()==0:
		var rot_multiplier:float=2.5 if ($GetRight.get_overlapping_bodies().size()==0)!=($GetLeft.get_overlapping_bodies().size()==0) else 1.5
		$CarBody.addlocaltorque("z",rotonair*rot_multiplier)
	
	if hastokill:
		translation=inittrans
		rotation=initrot
		hastokill=false
		globals.emit_signal("end")
		
	
	if abs(orders["front"])>0:
		if $AccelTimer.time_left==0 or sign(orders["front"])==last_direction or last_direction==0:
			$BackJoint.set("angular_motor_x/target_velocity",current_acceleration*orders["front"])
			$BackJoint.set("angular_motor_x/enabled",true)
			$BackJoint.set("angular_limit_x/enabled",false)
			$AccelTimer.start()
			last_direction=sign(orders["front"])
		else:
			$BackJoint.set("angular_limit_x/enabled",true)
	else:
		$BackJoint.set("angular_motor_x/enabled",false)
	
	if orders["side"]==0:
		$FrontJoint.set("angular_limit_y/lower_angle",0)
		$FrontJoint.set("angular_limit_y/upper_angle",0)
	else :
		$FrontJoint.set("angular_limit_y/lower_angle",-dir_rot_limit)
		$FrontJoint.set("angular_limit_y/upper_angle",dir_rot_limit)
		$FrontJoint.set("angular_motor_y/target_velocity",dir_rotation_speed*orders["side"])
		$CarBody.addlocaltorque("y",magical_rotation*orders["side"]*-orders["front"])
	
	if balancing:
		if $FrontWheel/FrontFloor.get_overlapping_bodies().size()<1 and rotation.x>0:
			$CarBody.addlocaltorque("x",-balancing_force)
		if $BackWheel/BackFloor.get_overlapping_bodies().size()<1 and rotation.x<0:
			$CarBody.addlocaltorque("x",balancing_force)


