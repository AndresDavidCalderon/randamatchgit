extends "res://ChunkTypes/chunk.gd"
func generate():
	dowall(true,false)
	add_child(load("res://ChunkTypes/grass/plain/plain.tscn").instance())

