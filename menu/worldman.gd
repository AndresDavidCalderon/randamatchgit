extends Node


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

var inited=false
func _on_start_pressed():
	inited=true
	startbut.disabled=true
	check.editable=false
	seeder.editable=false
