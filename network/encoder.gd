extends Node
export var iptocode:Dictionary
var codetoip:Dictionary={}
func _ready():
	var transferred=0
	while transferred<iptocode.keys().size():
		codetoip[iptocode[iptocode.keys()[transferred]]]=iptocode.keys()[transferred]
		transferred+=1
func tocode(ip:String,port)->String:
	port=str(port)
	var done=0
	var result=""
	var string=ip
	while true:
		var rest=string.right(done)
		var got=rest.length()
		var added:String
		while got>0:
			var now=rest.left(got)
			if iptocode.has(now):
				result+=iptocode[now]
				added=now
				break
			got-=1
		done+=added.length()
		if done==string.length():
			match string:
				ip:
					done=0
					result+="M"
					string=port
				port:
					break
	return result
func toip(code:String)->Array:
	var index=0
	var answer=["",""]
	var done=0
	while done<code.length():
		answer[index]+=codetoip[code[done]]
		done+=1
		if code[done]=="M":
			index=1
	answer[1]=int(answer[1])
	return answer
