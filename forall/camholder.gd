extends Spatial
export(Vector3) var baserot
onready var player=get_node("/root/main/player")
onready var target:Spatial=player
func _process(_delta):
	translation=target.global_transform.origin
	rotation.y=target.rotation.y+PI
	rotation+=baserot
