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

func getnewwall(hilltype):
	if not hilltype:
		return preload("res://forall/chunkconts/walls/jungle/junglewall.tscn").instance()
	else:
		return preload("res://forall/chunkconts/walls/jungle/todownbody.tscn").instance()

var player:RigidBody

func _on_killdown_body_entered(body):
	if body==player:
		player.kill()


func dowall(random:bool,hill:bool):
	match side:
		1:
			var wall=getnewwall(hill)
			add_child(wall)
			wall.translation.x=-30
		2:
			if random:
				if randman.randbool(30)==true:
					var wall_right=getnewwall(hill)
					add_child(wall_right)
					wall_right.translation.x=-30
		3:
			var wall=getnewwall(hill)
			add_child(wall)
			wall.translation.x=30
			if random:
				if randman.randbool(50)==true:
					var wall_right=getnewwall(hill)
					add_child(wall_right)
					wall_right.translation.x=-30
		4:
			var wall=getnewwall(hill)
			add_child(wall)
			wall.translation.x=30
			wall=getnewwall(hill)
			add_child(wall)
			wall.translation.x=-30

func setpos():
	pos=Vector3(round(translation.x/60),round((translation.y)/30),round(translation.z/60))
	forwup=Vector3(pos.x,pos.y+1,pos.z+1)
	forward=Vector3(pos.x,pos.y,pos.z+1)
	uppos=Vector3(pos.x,pos.y+1,pos.z)

func getnewchunk(script:Script,gentype:String="onvis")->Spatial:
	var new=load("res://forall/sistematic/chunk.tscn").instance() as Spatial
	new.set_script(script)
	new.gen=get_node("/root/main/generator")
	new.player=get_node("/root/main/player")

	return new


func created():
	gen=get_node("/root/main/generator")
	player=get_node("/root/main/player")
	add_to_group("chunks")
	gen.connect("make_row",self,"check_row")

func check_row(newrow:int):
	if newrow==stage:
		gen.disconnect("make_row",self,"check_row")
		call("defined")


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

func register():
	gen.chunkbypos[worldman.transtopos(translation)]=self


func _on_killdown_area_entered(area):
	if area!=get_node("dect") and area.get_parent().get("typestr")!=null and area.name!="killdown":
		$killdown.queue_free()
