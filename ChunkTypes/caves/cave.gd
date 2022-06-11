extends "res://ChunkTypes/chunk.gd"

var cavelong:int


func createcont(offset:Vector3,script:Script=worldman.chunkscript)->Spatial:
	var continuing=getnewchunk(script) as Spatial
	gen.add_child(continuing)
	share_info_to_chunk(continuing)
	if continuing.get("cavelong")!=null:
		continuing.cavelong=cavelong+1
	continuing.translation=Vector3(translation.x,translation.y,translation.z+60)+worldman.postotrans(offset)
	continuing.register()
	return continuing

func share_info_to_chunk(to:Spatial):
	to.side=side
	to.stage=stage+1
	to.column=column
