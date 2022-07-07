extends Node

signal pausing
signal debug_priority_changed(priority)
signal start
signal end

var on_match:bool=false

var debug_prority:bool=false
var console:Node2D
var res:resman
var camera
var ostype:String
var popuper:Panel

var playernd:Node
var car_body:RigidBody

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
		return
	if event.is_action_pressed("console"):
		debug_prority=not debug_prority
		emit_signal("debug_priority_changed",debug_prority)
	



func _on_globals_start():
	on_match=true


func _on_globals_end():
	on_match=false
