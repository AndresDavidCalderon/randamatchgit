##Makes sibling buttons a radio button list.
extends Node

signal selected(which)

var selected:Button

export var selected_index:int

func _ready():
	get_parent().call_deferred("move_child",self,get_parent().get_child_count())
	for i in get_parent().get_children():
		if i is Button:
			i.toggle_mode=true
			i.connect("toggled",self,"select",[i])
	
	if get_parent().get_child_count()>1:
		if get_parent().get_child(selected_index)==self:
			selected_index+=1
		get_parent().get_child(selected_index).pressed=true


func select(pressed:bool,node:Button):
	if pressed:
		if node!=selected:
			var selectedbefore=selected
			selected=node
			if selectedbefore!=null:
				selectedbefore.pressed=false
			emit_signal("selected",node.get_index())
	else:
		if node==selected:
			selected.pressed=true
	
