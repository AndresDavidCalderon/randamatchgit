extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var winorder=[]
var loadedids={}
var winorderbyid={}
var loaded=0
var hoverride=0
var winned=0
signal winupdate
signal allready
signal mustgo
# Called when the node enters the scene tree for the first time.
func _ready():
	winorder.resize(5)
var wseed:int
export(int) var checkfre
sync func win():
	if server.type=="server":
		var id=str(get_tree().get_rpc_sender_id())
		if not winorderbyid.has(id):
			winorder[winned]=id
			winorderbyid[id]=winned
			winned+=1
		rpc("updatewin",winned,winorder,winorderbyid)
sync func updatewin(wins,winorders,winids):
	winorderbyid=winids
	winned=wins
	winorder=winorders
	emit_signal("winupdate")
sync func updateload(loads,loadlist):
	loaded=loads
	loadedids=loadlist
	if loaded==server.players:
		emit_signal("allready")
		print("everyone is in!")
sync func imloaded():
	if server.type=="server":
		loaded+=1
		loadedids[str(get_tree().get_rpc_sender_id())]=true
		rpc("updateload",loaded,loadedids)
remote func emergencygo():
	if get_node_or_null("/root/menu")!=null:
		emit_signal("mustgo")
	else:
		rpc("imloaded")
onready var chunkscript=preload("res://forall/sistematic/chunk.gd")

func transtopos(trans):
	return Vector3(round(trans.x/60),round(trans.y/30),round(trans.z/60))

func postotrans(trans):
	return Vector3(round(trans.x*60),round(trans.y*30),round(trans.z*60))
