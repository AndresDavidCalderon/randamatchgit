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
	
	var floor_reference:CollisionShape=skin.get_node("Floor")
	get_parent().get_node("getflor").translation.x=floor_reference.translation.x
	get_parent().get_node("getflor").translation.y=floor_reference.translation.y
	get_parent().get_node("getflor/col").shape=floor_reference.shape
	
	last_skin=skin
	update_hat_pos()

var hat:Spatial

func set_hat(new_hat:Spatial):
	if hat!=null:
		hat.queue_free()
	hat=new_hat
	if hat!=null:
		get_parent().add_child(hat)
		for i in hat.get_node("Model").get_children():
			if i is MeshInstance:
				i.set_layer_mask_bit(1,true)
	update_hat_pos()

func update_hat_pos():
	if hat!=null:
		hat.translation=last_skin.get_node("HatSpot").translation
	
