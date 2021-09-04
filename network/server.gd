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
var iptocode={"1":"B","2":"C","3":"D","4":"E","5":"F","6":"G","7":"H","8":"I","9":"J",".":"K","0":"P"}
var codetoip={"B":"1","C":"2","D":"3","E":"4","F":"5","G":"6","H":"7","I":"8","J":"9","K":".","P":"0"}
func encode(ip:String,port:int,printlocal:bool):
	var ipencode=""
	var done=0
	if printlocal:
		prints("local",encode("127.0.0.1",41202,false))
	if ip.begins_with("192.168.1."):
		ipencode+="X"
		done+=10
		print("shortcut to encode applied")
	while done<ip.length():
		ipencode+=iptocode[ip[done]]
		done+=1
	prints("ip encoded:",ipencode)
	ipencode+="A"
	done=0
	while done<str(port).length():
		ipencode+=iptocode[str(port)[done]]
		done+=1
	prints("encode ended with result",ipencode)
	decode(ipencode)
	return ipencode
func decode(code:String):
	code=code.to_upper()
	var resultip=""
	var done=0
	var abort=false
	if code[0]=="X":
		done+=1
		resultip+="192.168.1."
		print("shortcut found on decode")
	while true:
		if done<code.length():
			if codetoip.has(code[done]) or code[done]=="A":
				if code[done]!="A":
					resultip+=codetoip[code[done]]
					done+=1
				else:
					print("entering port")
					done+=1
					break
			else:
				prints("carachter",code[done],"isnt keyd")
				abort=true
				break
		else:
			prints("code",code,"ended before finding the a")
			abort=true
			break
	var portres=""
	code.erase(0,done)
	done=0
	if not abort:
		while done<code.length() and codetoip.has(code[done]):
			portres+=codetoip[code[done]]
			done+=1
		prints("decode result",resultip,portres)
	else:
		resultip="error"
	return [resultip,int(portres)]
func connectserv(ip,port):
	var error=multman.create_client(ip,port)
	prints("connecting with error",error)
	if error==OK:
		get_tree().network_peer=multman
		type="client"
	else:
		multman=NetworkedMultiplayerENet.new()
	return error
