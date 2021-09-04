extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var myname=""
var myid:String
var predicts=false
onready var generator=get_node("/root/main/generator")
export(float) var gravity
# Called when the node enters the scene tree for the first time.
func settran(position,rotationarg):
	translation=position
	rotation=rotationarg
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _integrate_forces(state):
	if not predicts:
		state.transform.origin=translation
func _physics_process(_delta):
	move_and_slide(Vector3(0,-gravity,0))
func _ready():
	if generator.generated:
		$col.disabled=false
	else:
		generator.connect("generated",self,"gendone")
func gendone():
	$col.disabled=false
