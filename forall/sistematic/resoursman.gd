extends Node
export(Array,Resource) var initresources
var resources:Dictionary={}
class_name resman,"res://forall/sistematic/resman.png"
func _init():
	globals.res=self
func _ready():
	var changed=0
	while changed<initresources.size():
		var now=initresources[changed] as Resource
		resources[now.get_path()]=now
		changed+=1
	print(resources)
func getres(path:String)->Resource:
	if resources.has(path):
		return resources[path]
	else:
		var res=load(path) as Resource
		resources[path]=res
		globals.iprint(["loaded new resource",path])
		return res
