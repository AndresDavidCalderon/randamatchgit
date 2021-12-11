extends Spatial
var mounted=[null,null,null,null]
onready var mounter=[$driverseat]
func mount(who:Spatial,where:int):
	if who is PhysicsBody:
		who.add_collision_exception_with(get_parent())
	who.visible=false
	mounted[where]=who
	var rt=mounter[where].get_node("rt")
	rt.remote_path=rt.get_path_to(who)
func unmount(who:Spatial):
	var where=mounted.find(who)
	who.visible=true
	mounter[where].get_node("rt").remote_path=null
