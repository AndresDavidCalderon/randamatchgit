extends KinematicBody
var myname=""
var myid:String
var predicts=false
onready var generator=get_node("/root/main/generator")
export(float) var gravity
export(float) var transpeed
func settran(position,rotationarg):
	if translation.distance_to(position)>0:
		$trans.interpolate_property(self,"translation",translation,position,transpeed*(30/translation.distance_to(position)))
	translation=position
	rotation=rotationarg
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
