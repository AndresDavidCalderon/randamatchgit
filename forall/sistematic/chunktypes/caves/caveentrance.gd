extends "res://forall/sistematic/chunktypes/caves/cave.gd"
func defined():
	typestr="cavein"
	setpos()
	var forwdown=Vector3(pos.x,pos.y-1,pos.z+1)
	if not gen.chunkbypos.has(forwdown):
		cavelong=1
		dowall(true,false)
		add_child(preload("res://forall/chunkconts/hills/caves/ramptocavebody.tscn").instance() as StaticBody)
		var child=createcont(Vector3(0,-30,0),globals.res.getres("res://forall/sistematic/chunktypes/caves/cavetunnel.gd"),true)
		child.typestr="tunnel"
		child.created()
		gen.chunkbypos[Vector3(pos.x,pos.y-1,pos.z)]=self
