extends Node

export var mounted=false

func _on_car_needsorders():
	if not mounted:return
	if Input.is_action_pressed("right"):
		get_parent().orders.append("right")
		get_parent().orders.append("r")
	if Input.is_action_pressed("left"):
		get_parent().orders.append("left")
		get_parent().orders.append("l")
	if Input.is_action_pressed("forward"):
		get_parent().orders.append("accel")
	if Input.is_action_pressed("back"):
		get_parent().orders.append("brake")

