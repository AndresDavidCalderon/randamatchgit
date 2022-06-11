extends "res://ChunkTypes/chunk.gd"

func generate():
	dowall(true,true)
	add_child(preload("res://ChunkTypes/grass/hill/hill.tscn").instance())
