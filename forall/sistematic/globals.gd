extends Node
var console:Node2D
var res:resman
var camera
export(Dictionary) var consoleshorts
func iprint(text):
	if console==null or Engine.editor_hint:
			prints(text)
	else:
		if text is Array:
			console.printsline(text)
		else:
			console.printsline([text])
