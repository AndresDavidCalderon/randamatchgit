extends "res://gui/debug/blockbase.gd"

export(PackedScene) var argument
var argbuttons=[]
func _on_argcount_value_changed(value):
	if argbuttons.size()<value:
		var new=argument.instance() as input
		argbuttons.append(new)
		new.savename="argument"+str(argbuttons.size())
		new.rect_position.x=20*(argbuttons.size()-1)
		new.block=self
		$args.add_child(new)
	if argbuttons.size()>value:
		inputs.remove(argbuttons[value].index)
		argbuttons[value].queue_free()
		argbuttons.resize(value)
func customsave(dict:Dictionary):
	dict["argcount"]=$argcount.value
	dict["funcname"]=$funcname.text
func customload(dict:Dictionary):
	$argcount.value=dict["argcount"]
	_on_argcount_value_changed(dict["argcount"])
	$funcname.text=dict["funcname"]
func _on_run_pressed(bypress:bool):
	if bypress:
		get_parent().printsline(["#######"])
	var executer:Object
	if $from.target==null:
		executer=get_parent()
	else:
		$from.target.emit_signal("needsfill")
		if $from.target.value!=null:
			if typeof($from.target.value)==TYPE_OBJECT:
				executer=$from.target.value
			else:
				get_parent().canexecute=false
				get_parent().printsline(["invalid executer on",$funcname.text])
		else:
			get_parent().canexecute=false
			get_parent().printsline(["cant get executer on",$funcname.text])
	var argumentsfilled=0
	var arguments=[]
	while argumentsfilled<argbuttons.size():
		var button:Button=argbuttons[argumentsfilled]
		if button.target==null:
			executer=get_parent()
		else:
			button.target.emit_signal("needsfill")
			if $debugprint.pressed:
				get_parent().printsline(["argument",argumentsfilled,"request ended"])
			if button.target.value!=null:
				arguments.append(button.target.value)
			else:
				get_parent().canexecute=false
				get_parent().printsline(["cant fill argument",argumentsfilled,"on",$funcname.text])
		argumentsfilled+=1
	if get_parent().canexecute:
		if executer.has_method($funcname.text):
			$return.value=executer.callv($funcname.text,arguments)
			if $debugprint.pressed:
				get_parent().printsline([$funcname.text,"returned",$return.value])
			get_parent().printsline([$funcname.text,"called correctly"])
			if bypress:
				get_parent().emit_signal("executed")
		else:
			get_parent().canexecute=false
			get_parent().printsline([executer,"doesnt have",$funcname.text])
	else:
		get_parent().printsline(["something failed"])
		if bypress:
			get_parent().canexecute=true
func _on_return_needsfill():
	_on_run_pressed(false)


func _on_funcname_text_entered(_new_text):
	$funcname.release_focus()
