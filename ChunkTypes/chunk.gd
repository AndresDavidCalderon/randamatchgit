extends Spatial

var side:int
var stage:int
var column:int
var typestr=""
var pos:Vector3
var uppos=Vector3(pos.x,pos.y+1,pos.z)
var forwup=Vector3(pos.x,pos.y+1,pos.z+1)
var forward:Vector3
var stack:int
var gen:Node

func _ready():
	globals.connect("debug_priority_changed",self,"debug_priority")

func getnewwall(is_hill):
	if not is_hill:
		return preload("res://ChunkTypes/walls/plain/PlainWall.tscn").instance()
	else:
		return preload("res://ChunkTypes/walls/hill/HillWall.tscn").instance()

var player:Spatial

func _on_killdown_body_entered(body):
	if body==globals.car_body:
		player.kill()


func dowall(random:bool,hill:bool):
	match side:
		1:
			var wall=getnewwall(hill)
			add_child(wall)
			wall.scale.x=-1
		2:
			if random:
				if randman.randbool(30)==true:
					var wall_left=getnewwall(hill)
					add_child(wall_left)
					wall_left.scale.x=-1
		3:
			var wall=getnewwall(hill)
			add_child(wall)
			if random:
				if randman.randbool(50)==true:
					var wall_left=getnewwall(hill)
					add_child(wall_left)
					wall_left.scale.x=-1
func setpos():
	pos=Vector3(round(translation.x/60),round((translation.y)/30),round(translation.z/60))
	forwup=Vector3(pos.x,pos.y+1,pos.z+1)
	forward=Vector3(pos.x,pos.y,pos.z+1)
	uppos=Vector3(pos.x,pos.y+1,pos.z)

func getnewchunk(script:Script)->Spatial:
	var new=load("res://ChunkTypes/chunk.tscn").instance() as Spatial
	new.set_script(script)
	new.gen=get_node("/root/main/Generator")
	new.player=get_node("/root/main/player/CarBody")

	return new


func created():
	$Type.text=typestr
	gen=get_node("/root/main/Generator")
	player=get_node("/root/main/player/CarBody")
	
	gen.connect("make_row",self,"check_row")

func check_row(newrow:int):
	if newrow==stage:
		gen.disconnect("make_row",self,"check_row")
		call("generate")


func getresname(res:Resource)->String:
	var path:String=res.get_path()
	var from=path.length()-1
	var resname=""
	while from>0:
		if path[from]=="/":
			break
		else:
			resname+=path[from]
			from-=1
	return invertstring(resname)

func invertstring(phrase:String):
	var by=phrase.length()-1
	var result=""
	while by>=0:
		result+=phrase[by]
		by-=1
	return result

func register(extras:Array=[]):
	get_node("/root/main/Generator").chunkbypos[worldman.transtopos(translation)]=self
	for i in extras:
		get_node("/root/main/Generator").chunkbypos[worldman.transtopos(translation)+i]=self
	add_to_group("chunks")
	
func _on_killdown_area_entered(area):
	if area!=get_node("dect") and area.get_parent().get("typestr")!=null and area.name!="killdown":
		$killdown.queue_free()

func debug_priority(enabled:bool):
	$DebugLabel.no_depth_test=enabled
	$debug.no_depth_test=enabled
	$Type.visible=enabled
