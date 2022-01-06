extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player:RigidBody=get_node("/root/main/player")
onready var gen=get_node("/root/main/generator")
onready var playersync=get_node("/root/main/playervisman")
export(bool) var enabled
export(PackedScene) var indicator
# Called when the node enters the scene tree for the first time.
var pinbyorder=[]
func _ready():
	set_process(false)
	get_tree().connect("network_peer_disconnected",self,"gonout")
func gonout(id):
	var order=server.orderbyid[str(id)]-1
	if pinbyorder.size()>order:
		pinbyorder[order].queue_free()
	else:
		printerr("that player doesnt have a pin")
func _process(_delta):
	var base=position.x-(texture.get_width()/2.0)
	var positioned=0
	while positioned<server.players:
		if is_instance_valid(pinbyorder[positioned]):
			var entity
			var id=str(server.idbyorder[positioned+1])
			if id!=str(get_tree().get_network_unique_id()):
				if playersync.botbyid.has(id):
					entity=playersync.botbyid[id]
				else:
					prints("playersync doesnt have bot",positioned)
			else:
				entity=player
			if entity!=null and entity.translation.z-20!=0:
				var part=gen.terrlong/(entity.translation.z-20)
				if part!=0 and part>1:
					pinbyorder[positioned].position.x=base+(texture.get_width()/part)
		positioned+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_playervisman_botsended():
	print("creating car pins")
	pinbyorder.resize(server.players)
	var created=0
	while created<server.players:
		var pin=indicator.instance()
		add_child(pin)
		if server.idbyorder[created+1]!=get_tree().get_network_unique_id():
			pin.get_node("color").modulate=nameman.colorbyorder[created+1]
		else:
			pin.get_node("me").visible=true
			pin.z_index=1
		pinbyorder[created]=pin
		created+=1
	if enabled:
		set_process(true)
