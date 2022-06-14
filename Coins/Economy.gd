extends Node

signal coins_changed

var coins:int setget set_coins
var current_match_coins:int

func _ready():
	if not saver.loaded:
		yield(saver,"filedone")
	coins=saver.file["coins"]
	saver.connect("on_save",self,"on_save")
	globals.connect("start",self,"on_start")

func set_coins(value:int):
	if globals.on_match:
		current_match_coins+=value-coins
	coins=value
	emit_signal("coins_changed")

func on_start():
	current_match_coins=0

func on_save():
	saver.file["coins"]=coins
