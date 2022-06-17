extends ScrollContainer

export(Array,PackedScene) var skin_per_index:Array


func _on_RadioSelector_selected(which):
	globals.playernd.get_node("Skin").set_skin(skin_per_index[which].instance())
