extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Vector3) var baserot
onready var player=get_node("/root/main/player")
onready var target:Spatial=player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(_delta):
	translation=target.global_transform.origin
	rotation.y=target.rotation.y+PI
	rotation+=baserot

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
