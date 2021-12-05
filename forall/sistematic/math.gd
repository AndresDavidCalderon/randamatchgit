extends Node
func getantiscale(num:float)->float:
	return 1*(1/num)
func getloadpercentage(loader:ResourceInteractiveLoader)->float:
	return (float(loader.get_stage())/float(loader.get_stage_count()))*100
func vectorad(vec:Vector3):
	vec.x=deg2rad(vec.x)
	vec.y=deg2rad(vec.y)
	vec.z=deg2rad(vec.z)
	return vec
