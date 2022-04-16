extends Node

signal pausing

var console:Node2D
var res:resman
var camera
var ostype:String
var popuper:Panel

var playernd:Spatial

var paused=false

export(Dictionary) var consoleshorts
onready var defres=Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

func _init():
	match OS.get_name():
		"Android","iOS":
			ostype="mobile"
		"Windows","OSX","HTML5","UWP":
			ostype="desktop"

func _input(event):
	if event.is_action_pressed("pause"):
		paused=not paused
		emit_signal("pausing")
