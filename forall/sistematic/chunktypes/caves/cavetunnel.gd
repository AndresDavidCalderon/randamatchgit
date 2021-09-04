extends "res://forall/sistematic/chunktypes/caves/cave.gd"
var hilltype=1
func defined():
	setpos()
	print(gen)
	add_child(globals.res.getres("res://forall/chunkconts/hills/caves/cavetunnel.tscn").instance())
	if not gen.chunkbypos.has(forward):
		if randman.randbool(50) or cavelong<2:
			var tunnel=createcont(Vector3(),get_script(),true)
			tunnel.typestr="cavecont"
		else : #go out on plain
			if gen.chunkbypos.has(forwup):
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/uprandom.png")
				gen.chunkbypos[forwup].queue_free()
				var continuing=createcont(Vector3(0,30,0),worldman.chunkscript,true,"none")
				continuing.call("dowall",true,false)
				continuing.typestr="caveout"
				gen.chunkbypos[pos+Vector3(0,0,1)]=continuing
				var ramp=load("res://forall/chunkconts/hills/caves/ramptocavebody.tscn").instance() as StaticBody
				continuing.add_child(ramp)
				ramp.rotation_degrees.y=0
			else:
				$debug.texture=preload("res://forall/sistematic/debug/forwardnot.png")
	else:
		match gen.chunkbypos[forward].typestr:
			"hill":
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/tohill.png")
				gen.chunkbypos[forward].queue_free()
				var continuing=createcont(Vector3(),worldman.chunkscript,true)
				continuing.typestr="hillout"
				continuing.add_child(globals.res.getres("res://forall/chunkconts/hills/caves/torampbody.tscn").instance())
				continuing.call("dowall",true,true)
			"cavein","caveout":
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/replace.png")
				globals.console.printsline(["merging caves"])
				gen.chunkbypos[forward].queue_free()
				var replace=createcont(Vector3(0,30,0),globals.res.getres("res://forall/sistematic/chunktypes/plain.gd"),true)
				replace.typestr="plain"
				var tunnel=createcont(Vector3(),get_script(),true)
				tunnel.typestr="cavecont"
			_:
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/unknown.png")
