extends Node2D
onready var menuman=get_node("/root/menu")
export(NodePath) var tocode
func _on_create_pressed():
	if $edit.start():
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

var returns:Array
func _on_join_pressed():
	if $edit.start():
		returns=globals.popuper.popup("join","",[LineEdit,LineEdit,Button])
		returns[0].placeholder_text="ip"
		returns[0].text="127.0.0.1"
		returns[1].placeholder_text="port"
		returns[1].text="41202"
		returns[2].text="go"
		returns[2].connect("pressed",self,"doclient")
func doclient():
	var error=server.connectto(returns[0].text,int(returns[1].text))
	if error==OK:
		get_tree().connect("connected_to_server",self,"clientsuccess")
func clientsuccess():
	globals.popuper.unpopup()
	globals.camera.page(2)
	get_tree().disconnect("connected_to_server",self,"clientsuccess")
