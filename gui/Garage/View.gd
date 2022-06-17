extends ViewportContainer

func _ready():
	update_size()
	get_viewport().connect("size_changed",self,"update_size")

func update_size():
	$Viewport.size.x=get_viewport_rect().size.x
	$Viewport.size.y=get_viewport_rect().size.y-get_parent().get_node("Selection").rect_size.y
	rect_size=$Viewport.size
	$slide.rect_size=rect_size
	$slide.rect_size.y-=20
