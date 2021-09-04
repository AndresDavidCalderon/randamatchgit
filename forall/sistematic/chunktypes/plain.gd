extends "res://forall/sistematic/chunk.gd"
func defined():
	dirt(randman.randbool(50))
	dowall(true,false)
	if stage==gen.leng:
		add_child(preload("res://forall/chunkconts/end/flairarea.tscn").instance())
func dirt(isnoise):
	if isnoise==true:
		add_child(preload("res://forall/chunkconts/hills/terrvalleymb.tscn").instance())
	else:
		add_child(preload("res://forall/chunkconts/hills/valleyflat.tscn").instance())

