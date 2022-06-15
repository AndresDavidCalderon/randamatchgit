extends Spatial

export var rotation_speed:Vector2
var last_mouse_pos:=Vector2.ZERO
onready var garage:Control=get_parent().get_parent().get_node("UI/Garage")

func _process(delta):
	if last_mouse_pos!=Vector2.ZERO:
		rotation.y+=(last_mouse_pos.x-garage.get_global_mouse_position().x)*rotation_speed.x
		rotation.x+=(garage.get_global_mouse_position().y-last_mouse_pos.y)*rotation_speed.y
		rotation.x=clamp(rotation.x,0,PI)
		last_mouse_pos=garage.get_global_mouse_position()

func _on_slide_button_down():
	set_process(true)
	last_mouse_pos=garage.get_global_mouse_position()

func _on_slide_button_up():
	set_process(false)
