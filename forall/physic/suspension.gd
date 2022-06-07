extends CollisionShape

var default_pos=translation

export var lifted_offset:Vector3

var lifted_pos=default_pos+lifted_offset


func _on_front_body_entered(body):
	$Tween.interpolate_property(self,"translation",translation,lifted_pos,0.1)
	$Tween.start()


func _on_front_body_exited(body):
	$Tween.interpolate_property(self,"translation",translation,default_pos,0.1)
	$Tween.start()
