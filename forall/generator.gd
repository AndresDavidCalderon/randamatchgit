extends Node

signal generated
signal lined
signal lineend
signal newline

export(int,0,100) var hillprov

export(int) var betweencaves
export(int) var outsidechunks

onready var terrwide=server.players+2
export(int) var leng
onready var player=get_node("/root/main/player")
var terrlong:float
var pos=Vector3(0,-30,60)
var terrhei:float
var vislong:float
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

func _ready():
	if worldman.hoverride!=0:
		terrwide=worldman.hoverride
	var error=worldman.connect("allready",self,"start")
	box.width=(60*(terrwide+1))/2
	get_node("/root/main/floor/col").shape.extents.x=box.width-60

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

signal setscripts(to)

var doned=false
var is_hill:bool
var lastcave=4

func endgen():
	terrlong=(leng*60)-30
	terrhei=abs(terrhei)
	vislong=abs(pos.z)
	emit_signal("generated")

var can_be_hill=true

#when making every row of the world
func doline():
	var out=dones>leng
	
	#if the chunk can be a hill
	can_be_hill=true
	
	#chunk by row
	chunksbystage.append([])
	emit_signal("newline")
	for row in terrwide:
		var nod=chunk.instance() as Spatial
		add_child(nod)
		nod.translation=pos
		if is_hill:
			nod.set_script(plainscript)
			nod.typestr="plain"
		else:
			nod.set_script(hillscript)
			nod.typestr="hill"
		
		chunkbypos[Vector3(round(pos.x/60),round(pos.y/30),round(pos.z/60))]=nod
		
		pos.x+=60
		if dones>leng:
			nod.set_script(outscript)
		if randman.randbool(cavechance) and is_hill==false and dones<leng and lastcave>betweencaves:
			nod.set_script(cavescript)
			lastcave=0
			if terrhei<abs(pos.y)+30:
				terrhei+=30
			can_be_hill=false
		else:
			lastcave+=1
		emit_signal("setscripts",nod)
		
		#nod.side determines if 
		#its at the right or left of the track.
		nod.row=row
		if row==1:
			nod.side=1
		elif row==terrwide-1:
			nod.side=3
		else:
			nod.side=2
		
		if terrwide==2:
			nod.side=4
		
		connect("generated",nod,"onvisgen")
		nod.created()
		nod.stage=dones
		bycreated.append(nod)
		chunksbystage[dones].append(nod)
	
	emit_signal("lineend")
	if dones<leng and can_be_hill:
		is_hill=randman.randbool(hillprov)
		if is_hill:
			pos.y-=30
			terrhei+=30
	else:
		is_hill=false
	pos.z+=60
