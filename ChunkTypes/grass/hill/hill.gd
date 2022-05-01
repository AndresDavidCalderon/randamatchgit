extends "res://ChunkTypes/chunk.gd"

func defined():
	dowall(true,true)
	add_child(preload("res://ChunkTypes/grass/hill/hill.tscn").instance())
