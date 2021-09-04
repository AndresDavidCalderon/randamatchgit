extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var myorder:int
onready var creator=get_node("/root/menu/partyman/tr/nameman")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
func _process(_delta):
	if myorder!=null and server.idbyorder.size()>myorder:
		creator.buttbyid[str(server.idbyorder[myorder])]=self
		set_process(false)
		creator.update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
