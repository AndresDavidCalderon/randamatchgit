extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _ready():
	get_tree().connect("network_peer_connected",self,"newpeer")
export(NodePath) var checkpath
export(NodePath) var startpath
onready var startbut=get_node(startpath)
onready var check=get_node(checkpath)
onready var seeder=get_parent().get_node("seed")
func newpeer(id):
	update()
func update():
	if not inited:
		worldman.rpcmenu(self,"setstuff",[seeder.value,check.value],true)
func setstuff(see,checkarg):
	randman.random.seed=see
	seeder.value=see
	worldman.checkfre=checkarg
	check.value=checkarg
	prints("updated!",see,checkarg)
func start():
	print("starting")
	if server.type=="server":
		worldman.rpcmenu(self,"setstuff",[round(rand_range(0,120000)),round(rand_range(5,8))],true)
	else:
		check.editable=false
		seeder.editable=false


var inited=false
func _on_start_pressed():
	inited=true
	startbut.disabled=true
	check.editable=false
	seeder.editable=false
	


func _on_menu_createdserver():
	start()


func check(_value):
	if server.type=="server":
		update()
