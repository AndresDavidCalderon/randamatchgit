tool
extends aligner
export var buttons:PackedScene
var rowsid=[]
export(Array,Texture) var pics
export(Array,String) var titles
export(Array,String) var names
export(bool) var applydif
export(int) var rows setget updategridr
export(int) var columns setget updategridc
func updategridc(value):
	columns=value
	updategrid(0)
func updategridr(value):
	rows=value
	updategrid(0)
func updategridgen(_value):
	updategrid(rows)
func updategrid(_value):
	if Engine.editor_hint:
		var filled=0
		while filled<rows:
			if rowsid.size()<filled+1 or rowsid[filled]==null:
				rowsid.resize(filled+1)
				rowsid[filled]=[]
			print(rowsid[filled])
			var column=rowsid[filled] as Array
			var verticals=column.size()
			var first=true
			var y=0
			while verticals<columns:
				var new=buttons.instance() as Button
				if first:
					y=(column.size())*new.rect_size.y
					first=false
				add_child(new)
				new.rect_position.x=filled*new.rect_size.x
				new.rect_position.y=y
				var num=(rows*verticals-1)+filled+1
				print(num)
				if applydif:
					if pics.size()>num:
						new.get_node("pic").texture=pics[num]
					if names.size()>num:
						new.name=names[num]
					if titles.size()>num:
						new.get_node("title").text=titles[num]
				y+=new.rect_size.y
				if Engine.editor_hint:
					new.set_owner(get_tree().get_edited_scene_root())
				column.append(new)
				verticals+=1
			while columns<verticals:
				column[verticals-1].queue_free()
				verticals-=1
				column.resize(verticals)
			filled+=1
		while rowsid.size()>rows:
			print("less")
			var column=rowsid[rowsid.size()-1] as Array
			var verticals=column.size()
			while verticals>0:
				column[verticals-1].queue_free()
				verticals-=1
				column.resize(verticals)
			filled-=1
			rowsid.resize(rows)
