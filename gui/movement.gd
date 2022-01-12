extends Node2D

func _ready():
	if globals.technical_demo:
		queue_free()
