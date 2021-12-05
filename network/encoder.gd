extends Node
export var iptocode:Dictionary
var codetoip:Dictionary={}
func _ready():
	for i in iptocode.keys():
		codetoip[iptocode[i]]=i
func tocode(ip:String,port)->String:
	port=str(port)
	var done=0
	var result=""
	var string=ip
	while true:
		var rest=string.right(done)
		var added:String
		#numbers taken into account from rest
		var i=rest.length()
		while i>0:
			var now=rest.left(i)
			if iptocode.has(now):
				result+=iptocode[now]
				added=now
				break
			i-=1
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
	code=code.to_upper()
	var index=0
	var answer=["",""]
	var done=0
	while done<code.length():
		if code[done]=="M":
			index=1
			done+=1
		else:
			answer[index]+=codetoip[code[done]]
		done+=1
	print(answer)
	answer[1]=int(answer[1])
	return answer
