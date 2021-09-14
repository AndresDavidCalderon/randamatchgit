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
		get_node(tocode).get_node("code").text=server.get_node("encoder").tocode(ip,port)
		get_node("/root/menu/cam").page(2)

var returns:Array
func _on_join_pressed():
	if $edit.start():
		returns=globals.popuper.popup("join","",[LineEdit,Button]) as Array
		returns[0].placeholder_text="match code"
		returns[0].connect("text_changed",self,"codechange")
		returns[1].text="go"
		returns[1].connect("pressed",self,"usematch")
func codechange(text:String):
	returns[0].text=text.to_upper()
func usematch():
	var codes=server.get_node("encoder").toip(returns[0].text)
	doclient(codes[0],codes[1])
func doclientip():
	doclient(returns[0].text,int(returns[1].text))
func connectout():
	globals.popuper.popup("it took too long to connect","it may just not be doing anything, try again later.")
func doclient(ip,port):
	globals.popuper.unpopup()
	var error=server.connectto(ip,port)
	if error==OK:
		$connectout.start()
		$connectout.connect("timeout",self,"connectout")
		get_tree().connect("connected_to_server",self,"clientsuccess")
		get_tree().connect("connection_failed",self,"clientfail")
	else:
		globals.popuper.popup("we couldnt create a client for you","check the data you inserted or restart the game")
func clientfail():
	globals.popuper.popup("we had trouble connecting you","check your connection")
func clientsuccess():
	$connectout.stop()
	globals.camera.page(2)
	get_tree().disconnect("connected_to_server",self,"clientsuccess")


func _on_ip_pressed():
	returns=globals.popuper.popup("join by ip","",[LineEdit,LineEdit,Button])
	returns[0].placeholder_text="ip"
	returns[0].text="127.0.0.1"
	returns[1].placeholder_text="port"
	returns[1].text="41202"
	returns[2].text="go"
	returns[2].connect("pressed",self,"doclientip")
