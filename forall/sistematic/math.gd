extends Node
func getantiscale(num:float)->float:
	return 1*(1/num)
func getloadpercentage(loader:ResourceInteractiveLoader)->float:
	return (float(loader.get_stage())/float(loader.get_stage_count()))*100
