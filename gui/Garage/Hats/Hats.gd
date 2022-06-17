extends ScrollContainer

export(Array,PackedScene) var hats




func _on_RadioSelector_selected(which):
	if which==0:
		globals.playernd.get_node("Skin").set_hat(null)
	else:
		globals.playernd.get_node("Skin").set_hat(hats[which-1].instance())
