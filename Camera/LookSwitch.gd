extends Node

onready var main_cam:Camera=get_parent().get_node("cam")
onready var alt_cam:Camera=get_parent().get_node("BackCamera")

func _input(event):
	if event.is_action_pressed("LookBack"):
		main_cam.current=false
		alt_cam.current=true
	
	if event.is_action_released("LookBack"):
		main_cam.current=true
		alt_cam.current=false
		return
	
