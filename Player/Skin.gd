extends Node

export var default_skin:PackedScene
export var joint_template:PackedScene
export var wheel_template:PackedScene

func _ready():
	if default_skin!=null:
		set_skin(default_skin.instance())

var last_skin:Spatial

var collisions:=[]

var joints:=[]
var wheels:=[]

func set_skin(skin:car_template):
	if last_skin!=null:
		last_skin.queue_free()
	
	get_parent().get_node("CarBody").call_deferred("add_child",skin)
	
	var idx=0
	for i in get_parent().joints:
		var side=str(i).left(2)
		get_parent().get_node(side+"Wheel").translation=skin.get_node(side).translation
		get_parent().get_node(side+"Joint").translation=skin.get_node(side).translation
	
	for i in collisions:
		i.queue_free()
	collisions.clear()

	for path in skin.collissions:
		var i:CollisionShape=skin.get_node(path)
		i.get_parent().remove_child(i)
		get_parent().get_node("CarBody").call_deferred("add_child",i)
		collisions.append(i)

	for i in skin.get_node("Model").get_children():
		if i is MeshInstance:
			i.set_layer_mask_bit(1,true)
	
	var floor_reference:CollisionShape=skin.get_node("Floor")
	get_parent().get_node("CarBody/getflor").translation.x=floor_reference.translation.x
	get_parent().get_node("CarBody/getflor").translation.y=floor_reference.translation.y
	get_parent().get_node("CarBody/getflor/col").shape=floor_reference.shape
	
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
	
