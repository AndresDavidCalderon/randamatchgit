extends Node
export(int) var maxattempts
export(int) var maxclients
onready var multman=NetworkedMultiplayerENet.new()
onready var peerman=PacketPeerUDP.new()
var type="none"
remote var players=1
remote var orderbyid={"1":1}
remote var idbyorder=[0,1]
signal updated(type)
func _ready():
	idbyorder.resize(7)
	prints("newplayer init",get_tree().connect("network_peer_connected",self,"newplayer"))
func newplayer(id):
	if type=="server":
		players+=1
		orderbyid[str(id)]=players
		idbyorder[players]=id
		rset("players",players)
		rset("orderbyid",orderbyid)
		rset("idbyorder",idbyorder)
		rpc("playerlistupdate")
sync func playerlistupdate():
	emit_signal("updated","newplayer")
func startserv(port):
	var attempts=0
	var wassuc=false
	while attempts<maxattempts:
		var error=multman.create_server(port,maxclients)
		if error==OK:
			wassuc=true
			prints("server created succesfully in port",port)
			type="server"
			get_tree().network_peer=multman
			emit_signal("updated","servercreated")
			break
		else:
			prints("server creation failed, changing port from port",port,"with error",error)
			port+=1
		attempts+=1
	if not wassuc:
		print("server creation had enough errors for today")
	return port
func kill():
	multman.close_connection(1)
	players=0
	orderbyid={"1":1}
	idbyorder=[0,1]
	idbyorder.resize(7)
func connectto(ip,port):
	var error=multman.create_client(ip,port)
	prints("connecting with error",error)
	if error==OK:
		get_tree().network_peer=multman
		type="client"
	return error
