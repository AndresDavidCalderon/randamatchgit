extends player
func _on_generator_generated():
	if server.type!="none" and server.players>1:
		var totalspace=get_node("/root/main/generator").terrwide*30
		var partwide=totalspace/server.players
		var myspace=partwide*server.orderbyid[str(get_tree().get_network_unique_id())]
		translation.x=myspace-(totalspace/2)
	inittrans=translation
	initrot=rotation
	sleeping=false
	mode=MODE_RIGID
	$col.disabled=false
