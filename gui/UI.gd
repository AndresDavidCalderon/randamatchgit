extends CanvasLayer

func _ready():
	globals.connect("end",self,"on_end")
	$OnMatch.visible=false
	$Main.visible=true

func on_end():
	$OnMatch.visible=false
	$Main.visible=true


func _on_Garage_pressed():
	$Main.visible=false
	$Garage.visible=true


func _on_Exit_pressed():
	$Garage.visible=false
	$Main.visible=true
