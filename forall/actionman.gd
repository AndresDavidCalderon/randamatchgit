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
	worldman.rpc("win")
	worldman.connect("winupdate",self,"wincomfirm")
	$wintime.start($wintime.wait_time)
export(Array,Color) var wintexts
func wincomfirm():
	$wintime.stop()
	print("win updated")
	worldman.disconnect("winupdate",self,"wincomfirm")
	var celeb=get_parent().get_node("camholder/cam/top/celebration")
	celeb.visible=true
	celeb.text="#"+str(worldman.winned)
	if worldman.winned<4:
		celeb.set("custom_colors/font_color",wintexts[worldman.winned-1])
func _on_wintime_timeout():
	worldman.rpc("win")
