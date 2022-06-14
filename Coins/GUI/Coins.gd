extends HBoxContainer

func _ready():
	economy.connect("coins_changed",self,"on_coin_change")

func on_coin_change():
	$CurrentCoins.text=str(economy.current_match_coins)
	$TotalCoins.text="total:"+str(economy.coins)
	
