extends Node


func _on_car_needsorders():
	get_parent().orders={"front":Input.get_axis("back","forward"),"side":Input.get_axis("left","right")}
