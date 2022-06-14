extends Area



func _on_Coin_body_entered(body):
	if body==globals.playernd:
		saver.file["coins"]+=1
