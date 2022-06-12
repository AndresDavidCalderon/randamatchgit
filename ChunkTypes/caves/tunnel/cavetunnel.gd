extends "res://ChunkTypes/caves/cave.gd"

var supported_out_types:=["plain"]
var hilltype:="forward"
func generate():
	setpos()
	var offset=Vector3()
	
	#add our own structure
	var child
	match hilltype:
		"forward":
			child=globals.res.getres("res://ChunkTypes/caves/tunnel/straight/StraightTunnel.tscn").instance()
		"down":
			child=globals.res.getres("res://ChunkTypes/caves/tunnel/down/DownTunnel.tscn").instance()
			child.translation.y=-30
			offset.y=-1
		"up":
			child=globals.res.getres("res://ChunkTypes/caves/tunnel/down/DownTunnel.tscn").instance()
			child.rotation_degrees.y=180
			offset.y=1
	add_child(child)
	
	#continue the cave
	#check if spot is free
	if not gen.chunkbypos.has(forward+offset):
		if can_come_out():
			#go out on plain
			$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/uprandom.png")
			gen.chunkbypos[forwup].queue_free()
			var continuing=createcont(Vector3(0,1,0),gen.chunkbase)
			continuing.call("dowall",true,false)
			continuing.typestr="caveout"
			gen.chunkbypos[pos+Vector3(0,0,1)]=continuing
			var ramp=globals.res.getres("res://ChunkTypes/caves/entrance/CaveEntrance.tscn").instance() as StaticBody
			continuing.add_child(ramp)
			ramp.rotation_degrees.y=180
		else:
			continue_cave(offset)
	else:
		#if it isnt, react properly depending on whats there
		var obstructing_chunk:Spatial=gen.chunkbypos[forward+offset]
		match obstructing_chunk.typestr:
			"hill":
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/tohill.png")
				obstructing_chunk.queue_free()
				var continuing=createcont(offset,gen.chunkbase)
				continuing.typestr="hillout"
				continuing.add_child(globals.res.getres("res://ChunkTypes/caves/OutOnHill/OutOnHill.tscn").instance())
				continuing.call("dowall",true,true)
			
			"cavein","caveout":
				
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/replace.png")
				obstructing_chunk.queue_free()
				
				var warning=Sprite3D.new()
				warning.texture=preload("res://gui/debug/CaveOutReplace.png")
				get_node("/root/main").add_child(warning)
				warning.translation=obstructing_chunk.translation
				warning.translation.y+=30
				
				var replace=createcont(Vector3(0,1,0)+offset,globals.res.getres("res://ChunkTypes/grass/plain/plain.gd"))
				replace.typestr="plain"
				replace.generate()
				
				continue_cave(offset)
			"tunnel":
				if obstructing_chunk.hilltype=="down" and hilltype=="forward":
					$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/CaveDownReplace.png")
					obstructing_chunk.queue_free()
					
					var replacement=gen.chunk.instance()
					gen.add_child(replacement)
					replacement.set_script(get_script())
					replacement.typestr=typestr
					replacement.add_child(globals.res.getres("res://ChunkTypes/caves/tunnel/Connections/StraightDown/StraightDown.tscn").instance())
					share_info_to_chunk(replacement)
					replacement.translation=translation+Vector3(0,0,60)+worldman.transtopos(offset)
					replacement.register()
					replacement.continue_cave(Vector3())
					return
				if obstructing_chunk.hilltype=="straight" and hilltype=="up":
					$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/CaveDownReplace.png")
					obstructing_chunk.queue_free()
					var replacement=gen.chunk.instance()
					gen.add_child(replacement)
					replacement.set_script(get_script())
					replacement.typestr=typestr
					replacement.add_child(globals.res.getres("res://ChunkTypes/caves/tunnel/Connections/UpStraight/UpStraight.tscn").instance())
					share_info_to_chunk(replacement)
					replacement.translation=translation+Vector3(0,0,60)+worldman.transtopos(offset)
					replacement.register()
					replacement.continue_cave(Vector3())
					return
				if obstructing_chunk.hilltype==hilltype:
					continue_cave(offset)
					return
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/NoConnection.png")
				$DebugLabel.text=str(obstructing_chunk.hilltype)+"/"+hilltype
			var type:
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/unknown.png")
				$DebugLabel.text="type "+ type

#this is an if statement, just very long.
func can_come_out():
	if randman.randbool(30):
		return false
		#we just dont want to come out
	if cavelong<2:
		return false
		#cave is not long enough "cve"
	if hilltype!="forward":
		return false
		#we cant come out on a bad angle.
	if not gen.chunkbypos.has(forwup):
		return false
		#we cant go out on the void
	else:
		if not supported_out_types.has(gen.chunkbypos[forwup].typestr):
			return false
			#we cant replace a hill
	
	return true

func continue_cave(offset:Vector3,banned_directions:Array=[]):
	gen=get_node("/root/main/Generator")
	var tunnel=createcont(offset,get_script())
	tunnel.register([offset])
	var hillposibs:Array
	match hilltype:
		"forward":
			if not gen.chunkbypos.has(forwup):
				hillposibs=["up","down","forward","forward","up","down"]
			else:
				hillposibs=["down","forward","down"]
		"up":
			if not gen.chunkbypos.has(forwup):
				hillposibs=["up","up","forward"]
			else:
				hillposibs=["forward"]
		"down":
			hillposibs=["down","forward"]
	if cavelong>8:
		hillposibs.erase("down")
	for i in banned_directions:
		hillposibs.erase(banned_directions)
	tunnel.hilltype=randman.choose(hillposibs)
	tunnel.typestr="tunnel"
	tunnel.created()
