extends Node
class_name switcher,"res://UI/switcher.png"
var selected:Button
export(int) var selectedidx
signal selected(which)
func _ready():
	get_parent().call_deferred("move_child",self,get_parent().get_child_count())
	for i in get_parent().get_children():
		if i is Button:
			i.toggle_mode=true
			i.connect("toggled",self,"select",[i])
	if get_parent().get_child_count()>1:
		if get_parent().get_child(selectedidx)==self:
			selectedidx+=1
		get_parent().get_child(selectedidx).pressed=true

func select(pressed,node):
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
	
