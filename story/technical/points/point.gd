tool
extends Area
export(String) var caption
func _ready():
	if $rt.remote_path=="" or $rt.remote_path==null:
		var spr=preload("res://story/technical/points/pointspr.tscn").instance()
		spr.name=name
		get_parent().get_node("targetworld").add_child(spr)
		spr.set_owner(get_tree().get_edited_scene_root())
		$rt.remote_path=$rt.get_path_to(spr)
