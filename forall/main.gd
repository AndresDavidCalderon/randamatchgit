extends Node
func _ready():
	if server.players>1:
		worldman.rpc("imloaded")
		get_tree().connect("server_disconnected",self,"serverfail")
	else:
		worldman.emit_signal("allready")
func serverfail():
	$loadtime.disconnect("timeout",self,"serverfail")
	var button=globals.popuper.popup("seems like you got disconnected","",[Button],false)
	button[0].text="back to menu"
	button[0].connect("pressed",self,"menuback")
	$player/sync.set_process(false)
func menuback():
	server.kill()
	get_tree().change_scene("res://menu/menu.tscn")
var tries=0
export(int) var maxtries
func _on_loadtime_timeout():
	var checked=0
	if server.type=="server" and server.players>1:
		while checked<server.players:
			if not worldman.loadedids.has(str(server.idbyorder[checked+1])):
				worldman.rpc_id(server.idbyorder[checked+1],"emergencygo")
				globals.iprint([nameman.namebyrpc[str(server.idbyorder[checked+1])],"isnt here!"])
			checked+=1
	tries+=1
	if tries>maxtries:
		worldman.emit_signal("allready")
