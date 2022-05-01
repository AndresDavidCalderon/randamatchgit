extends "res://ChunkTypes/chunk.gd"
func defined():
	dowall(true,false)
	add_child(load("res://ChunkTypes/grass/plain/plain.tscn").instance())

