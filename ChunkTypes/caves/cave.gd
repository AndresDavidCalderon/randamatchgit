extends "res://ChunkTypes/chunk.gd"

var cavelong:int


func createcont(offset:Vector3,script:Script=worldman.chunkscript,register:bool=false)->Spatial:
	var continuing=getnewchunk(script) as Spatial
	gen.add_child(continuing)
	continuing.side=side
	continuing.stage=stage+1
	continuing.column=column
	if continuing.get("cavelong")!=null:
		continuing.cavelong=cavelong+1
	continuing.translation=Vector3(translation.x,translation.y,translation.z+60)+worldman.postotrans(offset)
	if register:
		gen.chunkbypos[worldman.transtopos(continuing.translation)]=continuing
	return continuing
