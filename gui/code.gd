extends aligner
func _on_ipshow_pressed():
	$ip.visible=not $ip.visible
	if $ip.visible:
		$ipshow.text="hide ip"
	else:
		$ipshow.text="show ip"


func _on_copy_pressed():
	OS.clipboard=$code.text
