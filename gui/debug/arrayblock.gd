extends "res://gui/debug/blockbase.gd"
var argbuttons=[]
export(PackedScene) var argument
func _on_size_value_changed(value):
	while argbuttons.size()<value:
		var new=argument.instance() as Button
		argbuttons.append(new)
		new.rect_position.x=6*(argbuttons.size())
		if rect_size.x-6<new.rect_position.x:
			rect_size.x=new.rect_position.x+6
		new.block=self
		$args.add_child(new)
	while argbuttons.size()>value:
		argbuttons[argbuttons.size()-1].queue_free()
		argbuttons.resize(argbuttons.size()-1)


func _on_return_needsfill():
	var array=[]
	while array.size()<argbuttons.size():
		var button=argbuttons[array.size()]
		if button.target.value==null:
			button.target.emit_signal("needsfill")
		array.append(button.target.value)
	$return.value=array
