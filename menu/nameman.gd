extends Node
var buttonscreated=0
var buttbyrpc={}
export(float) var buttony
func _ready():
	get_tree().connect("connected_to_server",self,"update")
	get_tree().connect("network_peer_connected",self,"newp")
	nameman.connect("updated",self,"update")
func newp(_id):
	update()
func update():
	print("upading names")
	while buttonscreated<server.players:
		var but:Node2D=load("res://menu/name.tscn").instance()
		get_parent().add_child(but)
		but.position=Vector2(-60,buttony)
		buttony+=50
		buttonscreated+=1
		var back=but.get_node("back")
		back.set("custom_styles/panel",back.get("custom_styles/panel").duplicate())
		back.get("custom_styles/panel").shadow_color=nameman.colorbyorder[buttonscreated]
		if server.idbyorder.size()>=buttonscreated:
			buttbyrpc[str(server.idbyorder[buttonscreated])]=but
		else:
			print("the server doesnt have the rpcid")
			but.myorder=buttonscreated
			but.set_process(true)
	var checked=1
	while checked<buttonscreated+1:
		prints("checking button",checked)
		if server.idbyorder.size()>=checked:
			if nameman.namebyrpc.has(str(server.idbyorder[checked])):
				var id=str(server.idbyorder[checked])
				var supname=nameman.namebyrpc[id]
				var text
				if buttbyrpc.has(id):
					text=buttbyrpc[id].get_node("name")
				else:
					prints("button",checked,"not found")
				if text.text!=supname:
					text.text=supname
					prints("name",checked,"corrected")
				else:
					prints("name",supname,"is right")
			else:
				print("the name manager doesnt know the name")
		else:
			print("the server doesnt have the id")
		checked+=1
