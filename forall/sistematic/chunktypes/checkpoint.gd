extends "res://forall/sistematic/chunk.gd"
func defined():
	add_child(preload("res://forall/chunkconts/check/leftbody.tscn").instance())
	dowall(false,false)
