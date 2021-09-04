extends Node2D
export(PackedScene) var funcblock
export(PackedScene) var varblock
export(bool) var bypress
signal needcons
signal clear
func _input(event):
	if bypress and event.is_action_pressed("console"):
		visible=not visible
		get_tree().set_input_as_handled()
var canexecute=true
signal executed
export(PackedScene) var arrayblock
var selectedout:Button
var selectedin:Button
signal needsave
func _on_add_pressed():
	var new:Panel=funcblock.instance()
	add_child(new)
	new.rect_position=$newblocks.rect_position

func _on_var_pressed():
	var new:Panel=varblock.instance()
	add_child(new)
	new.rect_position=$newblocks.rect_position
func printsline(text:Array):
	var printed=0
	var newtext=""
	while printed<text.size():
		newtext+=str(text[printed])+" "
		printed+=1
	$output.bbcode_text+=newtext+"\n"

func _init():
	globals.console=self
func _on_array_pressed():
	var new:Panel=arrayblock.instance()
	add_child(new)
	new.rect_position=$newblocks.rect_position
signal needssave
var blocks=[]
var fileman=File.new()
export(String) var savedir
func _on_save_pressed():
	emit_signal("needsave")
	emit_signal("needcons")
	if fileman.file_exists(savedir):
		Directory.new().remove(savedir)
	fileman.open(savedir,fileman.WRITE)
	fileman.store_string(JSON.print(blocks))
	fileman.close()
	blocks.clear()


func _on_load_pressed():
	emit_signal("clear")
	if fileman.file_exists(savedir):
		fileman.open(savedir,fileman.READ)
		var result=JSON.parse(fileman.get_as_text())
		if result.error==OK:
			var dict=result.result as Array
			var created=0
			while created<dict.size():
				match dict[created]["type"]:
					"func":
						addloadblock(funcblock)
					"var":
						addloadblock(varblock)
					"array":
						addloadblock(arrayblock)
					_:
						printsline(["invalid block type on file",dict[created]["type"]])
				created+=1
			created=0
			while created<dict.size():
				blocks[created].loadfile(dict[created])
				created+=1
			blocks.clear()
		else:
			printsline(["couldnt save",result.error_string])
		fileman.close()
	else:
		printsline([savedir,"does not exist"])
func addloadblock(scene:PackedScene):
	var new=scene.instance()
	blocks.append(new)
	add_child(new)


func clearwork():
	emit_signal("clear")


func _on_clearcons_pressed():
	$output.bbcode_text="\n"
