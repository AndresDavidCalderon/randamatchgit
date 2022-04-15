extends "res://forall/sistematic/chunk.gd"
var cavelong:int
func createcont(offset:Vector3,script:Script=worldman.chunkscript,register:bool=false,inittype="onvis")->Spatial:
	var continuing=getnewchunk(script,inittype) as Spatial
	gen.add_child(continuing)
	continuing.side=side
	continuing.stage=stage+1
	continuing.row=row
	if continuing.get("cavelong")!=null:
		continuing.cavelong=cavelong+1
	continuing.translation=Vector3(translation.x,translation.y,translation.z+60)+offset
	if register:
		gen.chunkbypos[worldman.transtopos(continuing.translation)]=continuing
	return continuing
