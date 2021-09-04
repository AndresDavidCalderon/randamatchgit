extends "res://forall/sistematic/chunk.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func defined():
	if randman.randbool(50):
		add_child(preload("res://forall/chunkconts/hills/valleyflat.tscn").instance())
	else:
		add_child(preload("res://forall/chunkconts/hills/terrvalleymb.tscn").instance())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
