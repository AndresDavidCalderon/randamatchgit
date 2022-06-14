extends CanvasLayer

func _ready():
	globals.connect("end",self,"on_end")
	$OnMatch.visible=false
	$Main.visible=true

func on_end():
	$OnMatch.visible=false
	$Main.visible=true
