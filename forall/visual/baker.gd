extends GIProbe
func _ready():
	pass
onready var gen=get_parent().get_node("generator")
onready var player=get_parent().get_node("player")
onready var dect=player.get_node("chunkdect")
export(bool) var enabled
func _on_generator_generated():
	if OS.get_current_video_driver()==OS.VIDEO_DRIVER_GLES3 and enabled:
		translation=Vector3(gen.terrwide/2,gen.terrhei/2,gen.vislong/2)
		extents=Vector3(gen.terrwide*60*3,gen.terrhei*2,gen.vislong*2)
		bake(get_parent())
	else:
		print("falled to gles2")
		get_parent().get_node("sun").light_bake_mode=DirectionalLight.BAKE_DISABLED

export(bool) var debugoptiz
func _on_chunkdect_area_entered(_area):
	var stage=dect.get_overlapping_areas()[0].get_parent().stage-10 as int
	var checks=get_parent().get_node("generator/checkman")
	if stage>0 and gen.chunksbystage.size()>stage and checks.stagebyid.has("self") and checks.stagebyid["self"]>stage:
		var hdone=0
		while hdone<gen.chunksbystage[stage].size():
			var inst=gen.chunksbystage[stage][hdone]
			if is_instance_valid(inst):
				inst.queue_free()
			hdone+=1
		if debugoptiz:
			globals.console.printsline(["optimized",stage])
	else:
		if debugoptiz:
			globals.console.printsline(["chunk doesnt exist",stage])
