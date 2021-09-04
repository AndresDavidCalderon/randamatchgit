extends "res://forall/sistematic/chunktypes/caves/cave.gd"
func defined():
	setpos()
	add_child(globals.res.getres("res://forall/chunkconts/hills/caves/torampbody.tscn").instance())
