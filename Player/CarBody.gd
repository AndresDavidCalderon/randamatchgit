extends RigidBody

func _integrate_forces(state):
	get_parent()._integrate_forces()
