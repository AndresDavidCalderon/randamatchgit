extends Node

export var automatic_suspension:float=10

func _on_front_body_entered(body):
	if get_parent().get_node("getback").get_overlapping_bodies().size()>0:
		get_parent().apply_local_torque_impulse("x",automatic_suspension)
		print("impulse")
