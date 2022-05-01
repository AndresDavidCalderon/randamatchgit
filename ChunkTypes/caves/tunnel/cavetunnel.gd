extends "res://ChunkTypes/caves/cave.gd"
var hilltype="forward"
func defined():
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
		if randman.randbool(30) or cavelong<2 or hilltype!="forward" or not gen.chunkbypos.has(forwup):
			var tunnel=createcont(Vector3()+worldman.postotrans(offset),get_script(),true)
			var hillposibs:Array
			match hilltype:
				"forward":
					if not gen.chunkbypos.has(forwup):
						hillposibs=["up","down","forward","forward","up"]
					else:
						hillposibs=["down","forward"]
				"up":
					if not gen.chunkbypos.has(forwup):
						hillposibs=["up","up","forward"]
					else:
						hillposibs=["forward"]
				"down":
					hillposibs=["down","forward"]
			tunnel.hilltype=randman.choose(hillposibs)
			tunnel.typestr="cavecont"
			tunnel.created()
		else : #go out on plain
			$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/uprandom.png")
			gen.chunkbypos[forwup].queue_free()
			var continuing=createcont(Vector3(0,30,0),gen.chunkbase,true,"none")
			continuing.call("dowall",true,false)
			continuing.typestr="caveout"
			gen.chunkbypos[pos+Vector3(0,0,1)]=continuing
			var ramp=globals.res.getres("res://ChunkTypes/caves/entrance/CaveEntrance.tscn").instance() as StaticBody
			continuing.add_child(ramp)
			ramp.rotation_degrees.y=180
	else:
		#if it isnt, react properly depending on whats there
		match gen.chunkbypos[forward+offset].typestr:
			"hill":
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/tohill.png")
				gen.chunkbypos[forward+offset].queue_free()
				var continuing=createcont(Vector3(),gen.chunkbase,true)
				continuing.typestr="hillout"
				continuing.add_child(globals.res.getres("res://ChunkTypes/caves/OutOnHill/OutOnHill.tscn").instance())
				continuing.call("dowall",true,true)
			"cavein","caveout":
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/replace.png")
				globals.console.printsline(["merging caves"])
				gen.chunkbypos[forward+offset].queue_free()
				var replace=createcont(Vector3(0,30,0),globals.res.getres("res://forall/sistematic/chunktypes/plain.gd"),true)
				replace.typestr="plain"
				var tunnel=createcont(Vector3(),get_script(),true)
				tunnel.typestr="cavecont"
			_:
				$debug.texture=globals.res.getres("res://ChunkTypes/caves/DebugIcons/unknown.png")
				
