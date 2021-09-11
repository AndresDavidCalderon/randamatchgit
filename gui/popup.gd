extends Panel
signal closed
func _init():
	globals.popuper=self
var normalsize=rect_size.y
var addedchild=[]
func _on_quit_pressed():
	unpopup()
func unpopup():
	globals.iprint("unpopuping")
	if visible:
		var cleared=0
		while cleared<addedchild.size():
			addedchild[cleared].queue_free()
			cleared+=1
		addedchild.clear()
		visible=false
		$vorder.rect_size.y=0
		$vorder.queue_sort()
	else:
		globals.iprint("already unpopuped")
func popup(title:String,desc="",fields:Array=[]):
	if visible:
		unpopup()
	visible=true
	var added=0
	$title.text=title
	var desclabel=$vorder/description
	desclabel.text=desc
	var instanced=[]
	while added<fields.size():
		var new=fields[added].new() as Control
		instanced.append(new)
		$vorder.add_child(new)
		addedchild.append(new)
		new.set("custom_fonts/font",preload("res://gui/smallfont.tres"))
		added+=1
	return instanced


func _on_vorder_sort_children():
	rect_size.y=($vorder.rect_position.y+$vorder.rect_size.y)+5
