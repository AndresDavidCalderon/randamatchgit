extends "res://forall/sistematic/chunk.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rampforward:PackedScene=preload("res://forall/chunkconts/forwards/forwbody.tscn")
func defined():
	dowall(true,true)
	hilldirt(randman.randbool(50))
	if randman.randbool(50):
		add_child(rampforward.instance())
func hilldirt(isnoise):
	if isnoise==false:
		add_child(preload("res://forall/chunkconts/hills/ramp.tscn").instance())
	else:
		add_child(preload("res://forall/chunkconts/hills/rampnoise.tscn").instance())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
