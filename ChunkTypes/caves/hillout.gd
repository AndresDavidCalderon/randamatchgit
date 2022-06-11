extends "res://ChunkTypes/caves/cave.gd"
func generate():
	add_child(globals.res.getres("res://forall/chunkconts/hills/caves/torampbody.tscn").instance())

