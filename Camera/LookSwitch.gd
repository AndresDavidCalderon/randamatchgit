extends Node

export var cameras:Dictionary

func _unhandled_input(event:InputEvent):
	for i in cameras.keys():
		if event.is_action(i):
			turn_off_all_exept(cameras[i])

func turn_off_all_exept(exept:NodePath):
	for i in cameras.values():
		get_node(i).current=i==exept
