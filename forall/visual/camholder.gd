extends Spatial
export(Vector3) var baserot
onready var target:Spatial=globals.playernd
func _process(_delta):
	translation=target.global_transform.origin
	rotation.y=target.rotation.y+PI
	rotation+=baserot
