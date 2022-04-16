extends Node

export(int,0,100) var hillprov

export(int) var betweencaves

var terrwide=3

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
	box.width=(60*(terrwide+1))/2

func _process(delta):
	if globals.playernd.translation.z>((rows_done-10)*60):
		doline()

var calling=false
var called=0
var rows_done=0

onready var box=get_node("/root/main/floor/box")

signal setscripts(to)

var doned=false
var is_hill:bool
var lastcave=4
var can_be_hill=true

#when making every row of the world
func doline():
	#if the chunk can be a hill
	can_be_hill=true
	
	#chunk by row
	chunksbystage.append([])
	emit_signal("newline")
	for column in terrwide:
		var nod=chunk.instance() as Spatial
		add_child(nod)
		nod.translation=pos
		if is_hill:
			nod.set_script(hillscript)
			nod.typestr="hill"
		else:
			nod.set_script(plainscript)
			nod.typestr="plain"
		
		chunkbypos[Vector3(round(pos.x/60),round(pos.y/30),round(pos.z/60))]=nod
		
		pos.x+=60
		
		if randman.randbool(cavechance) and is_hill==false and lastcave>betweencaves:
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
		nod.column=column+1
		if column==0:
			nod.side=1
		elif column==terrwide-1:
			nod.side=3
		else:
			nod.side=2
		
		nod.stage=rows_done
		bycreated.append(nod)
		chunksbystage[rows_done].append(nod)
	
		nod.created()
	
	emit_signal("lineend")
	
	if can_be_hill:
		is_hill=randman.randbool(hillprov)
		if is_hill:
			pos.y-=30
	else:
		is_hill=false
	
	pos.z+=60
	pos.x=0
	rows_done+=1
