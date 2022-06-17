extends Node

export var default_skin:PackedScene

func _ready():
	set_skin(default_skin.instance())

var collisions:=[]
var last_skin:Spatial
func set_skin(skin:Spatial):
	if last_skin!=null:
		last_skin.queue_free()
	
	get_parent().call_deferred("add_child",skin)
	
	get_parent().get_node("FrontWheel").translation=skin.get_node("WheelF").translation
	get_parent().get_node("BackWheel").translation=skin.get_node("WheelB").translation
	
	for i in collisions:
		i.queue_free()
	collisions.clear()
	
	var collision_container:Spatial=skin.get_node("Collisions")
	for i in collision_container.get_children():
		collision_container.remove_child(i)
		get_parent().call_deferred("add_child",i)
		collisions.append(i)
	
	for i in skin.get_node("Model").get_children():
		if i is MeshInstance:
			i.set_layer_mask_bit(1,true)
	
	last_skin=skin
	
