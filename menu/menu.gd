extends Node

func _ready():
	if globals.technical_demo:
		$partyman/br.start()
		$story.visible=false
		$multiplayer.visible=false
func _on_story_pressed():
	$topleftmain.gui="story"


func _on_multiplayer_pressed():
	$topleftmain.gui="multiplayer"
