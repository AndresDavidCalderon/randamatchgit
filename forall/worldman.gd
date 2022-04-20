extends Node

var checkfre=15

func transtopos(trans):
	return Vector3(round(trans.x/60),round(trans.y/30),round(trans.z/60))

func postotrans(trans):
	return Vector3(round(trans.x*60),round(trans.y*30),round(trans.z*60))
