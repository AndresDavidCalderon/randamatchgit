extends Node

func _ready():
	get_tree().connect("network_peer_connected",self,"setseed")
	random.randomize()

var random:RandomNumberGenerator=RandomNumberGenerator.new()
func randbool(posibility):
	var randbase=random.randf_range(0,100)
	if randbase<posibility:
		return true
	else:
		return false
func choose(posibilities:Array):
	var randbase=random.randi_range(0,posibilities.size()-1)
	return posibilities[randbase]
