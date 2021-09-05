extends Node
onready var syncer=get_node("/root/main/playervisman")
func _ready():
	set_process(false)
	worldman.connect("allready",self,"seton")
func _process(_delta):
	if server.players>1:
		syncer.rpc("changeplayer","settran",[get_parent().translation,get_parent().rotation])
func seton():
	set_process(true)
