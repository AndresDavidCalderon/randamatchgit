extends Node2D
onready var menuman=get_node("/root/menu")
export(NodePath) var tocode
func _on_create_pressed():
	var port=server.startserv(41202)
	get_node(tocode).get_node("port").text=str(port)
	var index
	match OS.get_name():
		"Android":
			index=0
		"Windows":
			index=1
	var ip=IP.get_local_addresses()[index]
	get_node(tocode).get_node("ip").text=str(ip)
	get_node(tocode).get_node("code").text=server.encode(ip,port,true)
	get_node("/root/menu/cam").page(2)
