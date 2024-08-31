extends Control
@onready var shop_panel = $ShopPanel

var shopPrices ={"medium_pot": 10,"small_pot": 5, "bonsai_pot": 10}

const SMALL_POT = preload("res://Scenes/Pots/SmallPot.tscn")
func _on_small_pot_pressed():
	if Global.gold >= shopPrices["small_pot"]:
		shop_panel.visible = false
		Global.is_dragging = true
		Global.placingItem = true
		var smallPot = SMALL_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(smallPot)
		smallPot.potSetup("smallPot")
		SignalBus.removeGold.emit(shopPrices["small_pot"])
		Global.itemCost = shopPrices["small_pot"]


const MEDIUM_POT = preload("res://Scenes/Pots/MediumPot.tscn")
func _on_medium_pot_pressed():
	if Global.gold >= shopPrices["medium_pot"]:
		shop_panel.visible = false
		Global.is_dragging = true
		Global.placingItem = true
		var medPot = MEDIUM_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(medPot)
		medPot.potSetup("mediumPot")
		SignalBus.removeGold.emit(shopPrices["medium_pot"])
		Global.itemCost = shopPrices["medium_pot"]


const BONSAI_POT = preload("res://Scenes/Pots/BonsaiPot.tscn")
func _on_bonsai_pot_2_pressed():
	if Global.gold >= shopPrices["bonsai_pot"]:
		shop_panel.visible = false
		Global.is_dragging = true
		Global.placingItem = true
		var bonsaiPot = BONSAI_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(bonsaiPot)
		bonsaiPot.potSetup("bonsaiPot")
		SignalBus.removeGold.emit(shopPrices["bonsai_pot"])
		Global.itemCost = shopPrices["bonsai_pot"]


func toggleVisible():
	shop_panel.visible = !shop_panel.visible

func setVisible(value:bool):
	shop_panel.visible = value
