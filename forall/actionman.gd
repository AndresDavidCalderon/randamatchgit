extends Node
var win=false
onready var player:RigidBody=get_node("/root/main/player")
func _ready():
	worldman.connect("allready",self,"onloaded")
func _unhandled_input(event):
	match event.as_text():
		"R":
			if not win:
				player.kill()
func onloaded():
	get_parent().get_node("loadtime").stop()
func onwin():
	win=true
	if not globals.technical_demo:
		worldman.rpc("win")
		worldman.connect("winupdate",self,"wincomfirm")
		$wintime.start($wintime.wait_time)
	else:
		wincomfirm()
export(Array,Color) var wintexts
func wincomfirm():
	$wintime.stop()
	print("win updated")
	worldman.disconnect("winupdate",self,"wincomfirm")
	var celeb=globals.camera.get_node("top/celebration")
	celeb.visible=true
	if not globals.technical_demo:
		celeb.text="#"+str(worldman.winned)
	else:
		celeb.text="#1"
	if worldman.winned<4:
		celeb.set("custom_colors/font_color",wintexts[worldman.winned-1])
	celeb.get_node("again").visible=globals.technical_demo
func _on_wintime_timeout():
	worldman.rpc("win")

func _on_again_pressed():
	get_tree().change_scene("res://menu/menu.tscn")
