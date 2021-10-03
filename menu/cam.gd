extends aligner
func page(pageidx):
	scaleview.x=pageidx-0.5
	setgui()
	saver.closeonback=pageidx<2
