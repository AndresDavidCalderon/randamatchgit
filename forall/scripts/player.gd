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
		$BackJoint.set("angular_motor_x/target_velocity",current_acceleration*orders["front"])
		$BackJoint.set("angular_motor_x/enabled",true)
	else:
		$BackJoint.set("angular_motor_x/enabled",false)
	
	if balancing:
		if $FrontWheel/FrontFloor.get_overlapping_bodies().size()<1 and rotation.x>0:
			$CarBody.addlocaltorque("x",-balancing_force)
		if $BackWheel/BackFloor.get_overlapping_bodies().size()<1 and rotation.x<0:
			$CarBody.addlocaltorque("x",balancing_force)

func set_direction_step(angle:float):
	$FrontJoint.rotation=angle
	$FrontWheel.rotation=angle
