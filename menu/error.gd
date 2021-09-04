extends "res://gui/sider.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var menuman=get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("server_disconnected",self,"onserverout")
func onserverout():
	menuman._on_back_pressed()
	visible=true
	$title.text="the player who hosted the game is now gone."


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_backtotitle_pressed():
	visible=false
