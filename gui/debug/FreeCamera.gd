extends Camera

export var rotation_speed:float
export var move_speed:float

func _input(event):
	if not current:
		translation=globals.playernd.get_node("CarBody").translation
	if event.is_action("rise"):
		translation.y+=move_speed
	if event.is_action("lower"):
		translation.y-=move_speed
		
	if event.is_action("forward_cam"):
		translation.z+=move_speed
	if event.is_action("back_cam"):
		translation.z-=move_speed
	
	if event.is_action("right_cam"):
		translation.x+=move_speed
	if event.is_action("left_cam"):
		translation.x-=move_speed

	if event.is_action("rot_l"):
		rotation.y+=rotation_speed
	if event.is_action("rot_r"):
		rotation.y-=rotation_speed
