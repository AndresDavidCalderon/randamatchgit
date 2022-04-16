extends "res://forall/sistematic/chunk.gd"
func defined():
	dirt(randman.randbool(50))
	dowall(true,false)

func dirt(isnoise):
	if isnoise==true:
		add_child(preload("res://forall/chunkconts/hills/terrvalleymb.tscn").instance())
	else:
		add_child(preload("res://forall/chunkconts/hills/valleyflat.tscn").instance())

