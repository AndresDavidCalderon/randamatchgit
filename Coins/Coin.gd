extends Area

export var icon_per_amount:Dictionary
export var max_icon:NodePath
export var amount:int=1 setget set_amount
export (float,0,100) var probability=20.0

func _ready():
	if randman.randbool(100-probability):
		queue_free()


func set_amount(total:int):
	amount=total
	var idx=0
	hide_all()
	for i in icon_per_amount.keys():
		idx+=1
		if i>amount:
			get_node(icon_per_amount[icon_per_amount.keys()[idx-1]]).visible=true
			return
	get_node(max_icon).visible=true
	
func hide_all():
	for i in icon_per_amount.values():
		get_node(i).visible=false


func _on_Coin_body_entered(body):
	if body==globals.playernd:
		economy.coins+=amount
		queue_free()
