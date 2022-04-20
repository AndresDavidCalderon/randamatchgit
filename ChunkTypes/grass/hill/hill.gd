extends "res://ChunkTypes/chunk.gd"

func defined():
	dowall(true,true)
	hilldirt()

func hilldirt():
	add_child(preload("res://ChunkTypes/grass/hill/hill.tscn").instance())
