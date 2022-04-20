extends "res://ChunkTypes/chunk.gd"
func defined():
	dirt()
	dowall(true,false)

func dirt():
	add_child(load("res://ChunkTypes/grass/models/valleyflat.tscn").instance())

