extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player:RigidBody=get_node("/root/main/player")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

onready var checkman=get_node("/root/main/generator/checkman")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
onready var pos=$all/elevator/appear
var connected=false
func newcheck():
	player.disconnect("kill",self,"playerdead")
	checkman.disconnect("newcheck",self,"newcheck")
func _on_checkarea_body_entered(body):
	if body==player:
		if not $name.visible:
			if checkman.stagebyid.has("self")==false or checkman.stagebyid["self"]<get_parent().stage:
				player.inittrans=pos.global_transform.origin
				player.initrot=Vector3(pos.rotation)
				checkman.stagebyid["self"]=get_parent().stage
				prints("new check",get_parent().stage)
				checkman.emit_signal("newcheck")
				if not connected:
					player.connect("kill",self,"playerdead")
					checkman.connect("newcheck",self,"newcheck")
					connected=true
			else:
				prints("you alraedy have the same check",get_parent().stage)
	elif body.get("myname")!=null and (checkman.stagebyid.has(body.myid)==false or checkman.stagebyid[body.myid]<get_parent().stage):
		print("taken!")
		$name.visible=true
		$name.texture=$view.get_texture()
		$view/base/label.text=body.myname
		checkman.stagebyid[body.myid]=get_parent().stage
onready var holder:Spatial=get_node("/root/main/camholder")
func resetphysics(state:PhysicsDirectBodyState):
	player.translation=pos.global_transform.origin
	state.transform.origin=pos.global_transform.origin
var connectedfis=false
func playerdead():
	if not connectedfis:
		connectedfis=true
		player.connect("onfis",self,"resetphysics")
	player.sleeping=true
	holder.target=$seer
	$spawn.play("spawn")
	wasremote=false
	rpc("playremote")
export(float) var adforce
func addfor():
	if not wasremote:
		var spat=player.tospatial(adforce,player.rotation.y)
		player.callonint("apply_central_impulse",[Vector3(spat.x,0,spat.y)])
func awake():
	if not wasremote:
		player.disconnect("onfis",self,"resetphysics")
		connectedfis=false
		player.sleeping=false
func _on_spawn_animation_finished(_anim_name):
	holder.target=player
var wasremote=false
remote func playremote():
	$spawn.play("spawn")
	wasremote=true
	print("remote animation")
