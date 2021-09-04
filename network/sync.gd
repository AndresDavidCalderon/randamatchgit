extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var syncer=get_node("/root/main/playervisman")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	worldman.connect("allready",self,"seton")
func _process(_delta):
	if server.players>1:
		syncer.rpc("changeplayer","settran",[get_parent().translation,get_parent().rotation])
func seton():
	set_process(true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
