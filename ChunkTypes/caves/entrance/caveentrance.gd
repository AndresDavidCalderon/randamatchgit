extends "res://ChunkTypes/caves/cave.gd"

func generate():
	typestr="cavein"
	setpos()
	var forwdown=Vector3(pos.x,pos.y-1,pos.z+1)
	if not gen.chunkbypos.has(forwdown):
		cavelong=1
		dowall(true,false)
		add_child(preload("res://ChunkTypes/caves/entrance/CaveEntrance.tscn").instance() as StaticBody)
		var child=createcont(Vector3(0,-1,0),globals.res.getres("res://ChunkTypes/caves/tunnel/cavetunnel.gd"))
		child.typestr="tunnel"
		child.hillposibs=["forward"]
		child.created()
