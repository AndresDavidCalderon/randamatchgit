extends Node

export(int,0,100) var hillprov

export(int) var betweencaves

var terrwide=3

onready var player=get_node("/root/main/player")
var pos=Vector3(0,-30,60)

export(int,0,100) var cavechance
var chunksbystage=[]
export(PackedScene) var chunk
export(Script) var chunkbase
export(Script) var hillscript
export(Script) var plainscript
export(Script) var cavescript

var chunkbypos={}
var bycreated=[]

signal make_row(row)

func _ready():
	randomize()
	box.width=(60*(terrwide+1))/2
	set_process(false)
	globals.connect("start",self,"set_process",[true])
	globals.connect("end",self,"reset")

func _process(_delta):
	if globals.playernd.translation.z>((rows_done-30)*60):
		
		doline()
		emit_signal("make_row",rows_done-20)

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
		
		chunkbypos[worldman.transtopos(nod.translation)]=nod
		
		pos.x+=60
		
		if randman.randbool(cavechance) and is_hill==false and lastcave>betweencaves:
			chunkbypos[worldman.transtopos(nod.translation)+Vector3(0,-1,0)]=nod
			
			nod.set_script(cavescript)
			nod.typestr="cavein"
			lastcave=0
			
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
		nod.add_to_group("chunks")
	
	if can_be_hill:
		is_hill=randman.randbool(hillprov)
		if is_hill:
			pos.y-=30
	else:
		is_hill=false
	
	pos.z+=60
	pos.x=0
	rows_done+=1

func reset():
	for i in get_tree().get_nodes_in_group("chunks"):
		i.queue_free()
	rows_done=0
	pos=Vector3(0,-30,0)
	chunkbypos.clear()
	chunksbystage.clear()
	set_process(false)
