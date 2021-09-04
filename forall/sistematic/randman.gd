extends Node

func _ready():
	get_tree().connect("network_peer_connected",self,"setseed")

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
var randseed=false
func setseed(_id):
	if server.type=="server":
		if not randseed:
			randseed=true
			randomize()
			random.seed=round(rand_range(1,120000))
			globals.iprint(["set seed",random.seed])
		rpc("syncseed",random.seed)
remote func syncseed(value):
	globals.iprint(["known seed",value])
	random.seed=value
