extends "res://forall/sistematic/chunktypes/caves/cave.gd"
var hilltype="forward"
func defined():
	setpos()
	print(gen)
	var offset=Vector3()
	match hilltype:
		"forward":
			add_child(globals.res.getres("res://forall/chunkconts/hills/caves/cavetunnel.tscn").instance())
		"down":
			var child=globals.res.getres("res://forall/chunkconts/hills/caves/todownbody.tscn").instance() as StaticBody
			add_child(child)
			child.translation.y=-30
			offset.y=-30
		"up":
			var child=globals.res.getres("res://forall/chunkconts/hills/caves/todownbody.tscn").instance() as StaticBody
			add_child(child)
			child.rotation_degrees.y=0
			offset.y=30
	if not gen.chunkbypos.has(forward+offset):
		if randman.randbool(70) or cavelong<2 or hilltype!="forward" or not gen.chunkbypos.has(forwup):
			var tunnel=createcont(Vector3()+offset,get_script(),true)
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
		else : #go out on plain
			$debug.texture=globals.res.getres("res://forall/sistematic/debug/uprandom.png")
			gen.chunkbypos[forwup].queue_free()
			var continuing=createcont(Vector3(0,30,0),worldman.chunkscript,true,"none")
			continuing.call("dowall",true,false)
			continuing.typestr="caveout"
			gen.chunkbypos[pos+Vector3(0,0,1)]=continuing
			var ramp=globals.res.getres("res://forall/chunkconts/hills/caves/ramptocavebody.tscn").instance() as StaticBody
			continuing.add_child(ramp)
			ramp.rotation_degrees.y=0
	else:
		match gen.chunkbypos[forward+offset].typestr:
			"hill":
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/tohill.png")
				gen.chunkbypos[forward+offset].queue_free()
				var continuing=createcont(Vector3(),worldman.chunkscript,true)
				continuing.typestr="hillout"
				continuing.add_child(globals.res.getres("res://forall/chunkconts/hills/caves/torampbody.tscn").instance())
				continuing.call("dowall",true,true)
			"cavein","caveout":
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/replace.png")
				globals.console.printsline(["merging caves"])
				gen.chunkbypos[forward+offset].queue_free()
				var replace=createcont(Vector3(0,30,0),globals.res.getres("res://forall/sistematic/chunktypes/plain.gd"),true)
				replace.typestr="plain"
				var tunnel=createcont(Vector3(),get_script(),true)
				tunnel.typestr="cavecont"
			_:
				$debug.texture=globals.res.getres("res://forall/sistematic/debug/unknown.png")
				
