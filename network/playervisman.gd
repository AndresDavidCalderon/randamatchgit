extends Node
var botbyid={}
export(PackedScene) var playersource
signal botsended
func _ready():
	worldman.connect("allready",self,"onallload")
# Called when the node enters the scene tree for the first time.
func onallload():
	if server.players>1:
		var done=0
		while done<server.players:
			done+=1
			if get_tree().get_network_unique_id()!=0 and done!=server.orderbyid[str(get_tree().get_network_unique_id())]:
				var par=playersource.instance()
				par.myid=str(server.idbyorder[done])
				add_child(par)
				botbyid[str(server.idbyorder[done])]=par
				par.myname=nameman.namebyrpc[str(server.idbyorder[done])]
	emit_signal("botsended")
remote func changeplayer(fun,arguments):
	if botbyid.has(str(get_tree().get_rpc_sender_id())):
		botbyid[str(get_tree().get_rpc_sender_id())].callv(fun,arguments)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
