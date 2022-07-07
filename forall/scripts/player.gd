extends Spatial
class_name car,"res://Player/player.png"
signal needsorders
export(float) var acceleration
#max speed is set on the joint scene

export(float) var rotspeed
export(float) var rotonair
export(float) var jump_force

export var dir_rotation_speed:float
export var dir_rot_limit:float

#rotation added through add_torque and not through the wheels.
export var magical_rotation:float

export(Array,NodePath) var force_joints:=[]
export(Array,NodePath) var steer_joints:=[]
export(Array,NodePath) var joints:=[]

signal kill

func _init():
	globals.playernd=self

func _ready():
	globals.car_body=$CarBody

func kill():
	get_tree().reload_current_scene()

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


func _on_CarBody_on_integrate_forces(_state):
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
	
	if $CarBody/FrontFloor.get_overlapping_bodies().size()==0 or $CarBody/BackFloor.get_overlapping_bodies().size()==0:
		current_acceleration/=2
		if orders["front"]>0:
			$CarBody.addlocaltorque("x",-rotonair*orders["front"])
		elif orders["front"]<0:
			$CarBody.addlocaltorque("x",rotonair*5*orders["front"])
	
	if $CarBody/GetRight.get_overlapping_bodies().size()==0 or $CarBody/GetLeft.get_overlapping_bodies().size()==0:
		var rot_multiplier:float=2.5 if ($CarBody/GetRight.get_overlapping_bodies().size()==0)!=($CarBody/GetLeft.get_overlapping_bodies().size()==0) else 1.5
		$CarBody.addlocaltorque("z",rotonair*rot_multiplier)
	
	
	if abs(orders["front"])>0:
		for path in force_joints:
			var i=get_node(path)
			i.set("angular_motor_x/target_velocity",current_acceleration*orders["front"])
			i.set("angular_motor_x/enabled",true)
		last_direction=sign(orders["front"])
	else:
		for path in force_joints:
			get_node(path).set("angular_motor_x/enabled",false)
	
	if orders["side"]==0:
		for path in steer_joints:
			var i=get_node(path)
			i.set("angular_limit_y/lower_angle",0)
			i.set("angular_limit_y/upper_angle",0)
	else :
		for path in steer_joints:
			var i=get_node(path)
			i.set("angular_limit_y/lower_angle",-dir_rot_limit)
			i.set("angular_limit_y/upper_angle",dir_rot_limit)
			i.set("angular_motor_y/target_velocity",dir_rotation_speed*orders["side"])
		$CarBody.addlocaltorque("y",magical_rotation*orders["side"]*-orders["front"])
	

