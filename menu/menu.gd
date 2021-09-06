extends Node
export(String) var saveloc
export(NodePath) var loadbarpath
onready var loadbar=get_node(loadbarpath)
signal createdserver
onready var resload=ResourceLoader.load_interactive("res://forall/main.tscn")
var fileman=File.new()
func _ready():
	if fileman.file_exists(saveloc):
		fileman.open(saveloc,File.READ)
		var res=JSON.parse(fileman.get_as_text())
		prints("parsed save",res.error)
		if res.error==OK:
			$topleftmain/name.text=res.result["name"]
			nameman.usname=res.result["name"]
		fileman.close()
	randomize()
	get_tree().connect("network_peer_connected",self,"newplayer")
	set_process(false)
remote func newplayer(id):
	if onserver:
		rpc("setmatch",$partyman/code/code.text)
	if onserver:
		rpc("newplayer",id)
	print("syncing players")
	$partyman/tr/lab.text=str(server.players)+"/5"
var onserver=null
func _on_new_pressed():
	restartinterfaces()
	if $topleftmain/name.text=="username":
		$nameman.visible=true
	else:
		onserver=true
		startserv()
		page2()
		emit_signal("createdserver")
	onserver=true
func _on_comfirm_pressed():
	$nameman.visible=false
	nameman.usname=$nameman/entername.text
	match onserver:
		true:
			startserv()
		false:
			$joinman.visible=true
	$topleftmain/name.text=nameman.usname
	var filexisted=fileman.file_exists(saveloc)
	fileman.open(saveloc,File.WRITE_READ)
	var fil
	if filexisted:
		var filres=JSON.parse(fileman.get_as_text())
		if filres.error==OK:
			fil=filres.result
		else:
			fil={}
	else:
		fil={}
	fil["name"]=nameman.usname
	fileman.store_string(JSON.print(fil))
	fileman.close()
func startserv():
	var port=server.startserv(41202)
	$partyman/code/port.text=str(port)
	var index
	match OS.get_name():
		"Android":
			index=0
		"Windows":
			index=1
	var ip=IP.get_local_addresses()[index]
	$partyman/code/ip.text=str(ip)
	$partyman/code/code.text=server.encode(ip,port,true)
	page2()
func _on_join_pressed():
	onserver=false
	if $topleftmain/name.text!="username":
		$joinman.visible=true
	else:
		$nameman.visible=true


func _on_back_pressed():
	onserver=null
	server.kill()
	$cam.scaleview=Vector2(0.5,0.5)
	$cam.setgui()


onready var codespace=$joinman/entername
func _comfirmmatch():
	var res=server.decode(codespace.text)
	var error=server.connectserv(res[0],res[1])
	waitforsucs()
var connectedtotree=false
func waitforsucs():
	$connectout.start($connectout.wait_time)
	if not connectedtotree:
		get_tree().connect("connected_to_server",self,"connectedasclient")
		get_tree().connect("connection_failed",self,"connectionfailed")
		connectedtotree=true
func connectedasclient():
	restartinterfaces()
	$connectout.stop()
	page2()
func _on_ipshow_pressed():
	var lab=$partyman/code/ip
	var but=$partyman/code/ipshow
	lab.visible=not lab.visible
	match lab.visible:
		false:
			but.text="show ip"
		true:
			but.text="hide ip"
func _process(_delta):
	var result=resload.poll()
	match result:
		OK:
			loadbar.value=resload.get_stage()
		ERR_FILE_EOF:
			go()
		_:
			print("error loading scene")
			$cam/error/back.connect("pressed",self,"_on_back_pressed")
			$cam/error.visible=true
func _on_copy_pressed():
	OS.set_clipboard($partyman/code/code.text)
remote func page2():
	$cam.scaleview.x=1.5
	$cam.setgui()
	if not onserver:
		$partyman/code/ipshow.visible=false
		$partyman/code/port.visible=false
		$partyman/br/start.visible=false
	else:
		randman.setseed(0)
	get_tree().refuse_new_network_connections=false

func _on_entername_text_changed(_new_text):
	codespace.disconnect("text_changed",self,"_on_entername_text_changed")
	$joinman/comfirm.visible=true

func restartinterfaces():
	$joinman.visible=false
	$ipman.visible=false
	$joinman.visible=false
	$nameman.visible=false

func _on_ip_pressed():
	$joinman.visible=false
	$ipman.visible=true


func ipgo():
	var error=server.connectserv($ipman/ip.text,int($ipman/port.text))
	if error==OK:
		waitforsucs()
	else:
		$ipman.visible=false
		$cam/error/back.connect("pressed",self,"_on_ip_pressed")
		showerror(error)

func showerror(error):
	error=str(error)
	$cam/error.visible=true
	match error:
		"22":
			$cam/error/title.text="you tried before and we couldnt refresh some stuff. error#"+str(error)
		"26":
			$cam/error/title.text="you probably typed it wrong. error#"+str(error)
		_:
			$cam/error/title.text="something went wrong when connecting, we just cant explain. code#"+str(error)

remote func setmatch(code):
	$partyman/code/code.text=code
func _on_backtofri_pressed():
	page2()
	rpc("page2")

func _on_randseed_pressed():
	$matchman/ul/seed.value=round(rand_range(0,10000000))
var menuispaused
remote func startload():
	set_process(true)
	loadbar.max_value=resload.get_stage_count()
func go():
	var error=get_tree().change_scene_to(resload.get_resource())
	match error:
		OK:
			print("nice!")
		_:
			$cam/error.visible=true
			$cam/error/title.text="the world loaded, but we just cant go. error #"+str(error)

func _on_port_text_entered(_new_text):
	ipgo()


func _on_ip_text_entered(_new_text):
	$ipman/port.grab_focus()


func _on_edit_pressed():
	restartinterfaces()
	$nameman.visible=true


func _on_entername_text_entered(_new_text):
	if $nameman/entername.text!="":
		$nameman/comfirm.emit_signal("pressed")


func gotomatch():
	startload()
	menuispaused=true
	rpc("startload")

func _on_close_pressed():
	get_tree().quit()

func _on_connectout_timeout():
	$connectout.stop()
	restartinterfaces()
	$cam/error.visible=true
	$cam/error/title.text="we couldnt connect, or at least it took to long so we thought we couldnt."
