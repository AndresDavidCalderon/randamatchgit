extends RigidBody

func _integrate_forces(state):
	get_parent()._integrate_forces()

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
