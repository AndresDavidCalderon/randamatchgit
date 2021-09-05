extends Node
var stagebyid={}
var checkbyid={}
signal newcheck
var ischeck=false
var tonextcheck=worldman.checkfre
export(Script) var checkscript
func _on_generator_lineend():
	ischeck=fmod(get_parent().dones,worldman.checkfre)==0 and get_parent().dones<get_parent().leng-6
	tonextcheck-=1
	if ischeck:
		get_parent().candown=false
		tonextcheck=worldman.checkfre
func _on_generator_setscripts(to:Spatial):
	if ischeck:
		to.set_script(checkscript)
