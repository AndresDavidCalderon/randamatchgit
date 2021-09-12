extends Node
var namebyrpc={}
export(Array,Color) var colorbyorder
export(String) var usname
signal updated
func _ready():
	server.connect("updated",self,"update")
	randomize()
func update(_type):
	rpc("setname",usname)
	if server.type=="server":
		rpc("setwhole",namebyrpc)
sync func setname(usnamearg):
	namebyrpc[str(get_tree().get_rpc_sender_id())]=usnamearg
	if server.type=="server":
		rpc("setwhole",namebyrpc)
	emit_signal("updated")
remote func setwhole(list):
	namebyrpc=list
	prints("the server told all the list",list)
	emit_signal("updated")
