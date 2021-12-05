extends aligner
func _on_ipshow_pressed():
	$ip.visible=not $ip.visible
	if $ip.visible:
		$ipshow.text="hide ip"
	else:
		$ipshow.text="show ip"


func _on_copy_pressed():
	OS.clipboard=$code.text
func setcode(ip,port):
	print(ip,port)
	var code=server.get_node("encoder").tocode(ip,port)
	$code.text=code
	$back.rect_size.x=$code.rect_size.x+10
	$copy.rect_position.x=$back.rect_size.x-$copy.rect_size.x/2
	$ip.text=ip
