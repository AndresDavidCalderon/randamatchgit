extends aligner
func _ready():
	server.connect("updated",self,"onupd")
func onupd(_type:String):
	$lab.text=str(server.players)+"/5"
