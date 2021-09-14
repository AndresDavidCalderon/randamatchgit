extends Node
signal generated
signal lined
signal lineend
signal newline
export(int,0,100) var hillprov
export(int) var betweencaves
export(String,"bystep","onframe","byvis") var genmode
export(int) var outsidechunks
onready var terrwide=server.players+2
export(int) var leng
onready var player=get_node("/root/main/player")
var terrlong:float
var pos=Vector3(0,-30,60)
var terrhei:float
var vislong:float
export(bool) var stepbystep
var generated=false
export(int,0,100) var cavechance
var chunksbystage=[]
export(PackedScene) var chunk
export(Script) var chunkbase
export(Script) var hillscript
export(Script) var plainscript
export(Script) var outscript
export(Script) var cavescript
var checkwall:Area
var chunkbypos={}
var bycreated=[]
func start():
	print("generating!")
	if stepbystep==false:
		set_process(false)
		while dones<leng+outsidechunks:
			doline()
		endgen()
func _ready():
	if worldman.hoverride!=0:
		terrwide=worldman.hoverride
	var error=worldman.connect("allready",self,"start")
	box.width=(60*(terrwide+1))/2
	get_node("/root/main/floor/col").shape.extents.x=box.width-60
	pos.x=startpos
var calling=false
var called=0
var dones=0
func _process(_delta):
	if not calling:
		if dones<leng+outsidechunks:
			doline()
		else:
			set_process(false)
			endgen()
	else:
		if called<bycreated.size():
			if is_instance_valid(bycreated[called]):
				bycreated[called].defined()
			else:
				prints("chunk",called,"isnt there")
			called+=1
		else:
			set_process(false)
			generated=true
			emit_signal("generated")
onready var box=get_node("/root/main/floor/box")
onready var startpos=makexpos(terrwide)
signal setscripts(to)
var doned=false
var changetype:int
var lastcave=4
func endgen():
	terrlong=(leng*60)-30
	terrhei=abs(terrhei)
	vislong=abs(pos.z)
	print("all chunks created")
	match genmode:
		"onframe":
			emit_signal("lined")
			emit_signal("generated")
			generated=true
		"bystep":
			calling=true
			set_process(true)
		"byvis":
			emit_signal("generated")
var candown=true
func doline():
	var out=dones>leng
	var h=1
	candown=true
	chunksbystage.append([])
	emit_signal("newline")
	while (h<terrwide) or (out and h<terrwide*3):
		var nod=chunk.instance() as Spatial
		add_child(nod)
		nod.translation=pos
		match changetype:
			0:
				nod.set_script(plainscript)
				nod.typestr="plain"
			1:
				nod.set_script(hillscript)
				nod.typestr="hill"
		chunkbypos[Vector3(round(pos.x/60),round(pos.y/30),round(pos.z/60))]=nod
		pos.x+=60
		if dones>leng:
			nod.set_script(outscript)
		if randman.randbool(cavechance) and changetype==0 and dones<leng and lastcave>betweencaves and $checkman.tonextcheck>4:
			nod.set_script(cavescript)
			lastcave=0
			if terrhei<abs(pos.y)+30:
				terrhei+=30
			candown=false
		else:
			lastcave+=1
		emit_signal("setscripts",nod)
		nod.h=h
		if h==1:
			nod.side=1
		elif h==terrwide-1:
			nod.side=3
		else:
			nod.side=2
		if terrwide==2:
			nod.side=4
		h+=1
		match genmode:
			"onframe":
				connect("lined",nod,"defined")
			"byvis":
				connect("generated",nod,"onvisgen")
		nod.created()
		nod.stage=dones
		bycreated.append(nod)
		chunksbystage[dones].append(nod)
	dones+=1
	if dones>leng and not doned:
		checkwall=load("res://forall/chunkconts/end/endzone.tscn").instance()
		checkwall.translation=Vector3(startpos,pos.y,pos.z+60)
		checkwall.get_node("col").shape.extents=Vector3(60*terrwide,terrhei,2)
		add_child(checkwall)
		checkwall.connect("body_entered",self,"win")
		startpos=startpos*3-60
		doned=true
	pos.x=startpos
	emit_signal("lineend")
	if dones<leng and candown:
		changetype=randman.randbool(hillprov)
		if changetype==1:
			pos.y-=30
			terrhei+=30
	else:
		changetype=0
	pos.z+=60
func makexpos(wide):
	return -(((60*(wide))/2)-60)
onready var actionman=get_node("/root/main/actionman")
func win(body):
	if body==player:
		print("winn")
		checkwall.disconnect("body_entered",self,"win")
		get_node("/root/main/camholder").set_process(false)
		get_node("/root/main/actionman").onwin()
