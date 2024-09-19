extends Control

var shopPrices ={"medium_pot": 10,"small_pot": 5, "bonsai_pot": 10, "mystery_seed_tier_1": 25}

const SMALL_POT = preload("res://Scenes/Pots/SmallPot.tscn")
func _on_small_pot_pressed():
	if Global.gold >= shopPrices["small_pot"]:
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
		Global.is_dragging = true
		Global.placingItem = true
		var medPot = MEDIUM_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(medPot)
		medPot.potSetup("mediumPot")
		SignalBus.removeGold.emit(shopPrices["medium_pot"])
		Global.itemCost = shopPrices["medium_pot"]


const BONSAI_POT = preload("res://Scenes/Pots/BonsaiPot.tscn")
func _on_bonsai_pot_pressed():
	if Global.gold >= shopPrices["bonsai_pot"]:
		Global.is_dragging = true
		Global.placingItem = true
		var bonsaiPot = BONSAI_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(bonsaiPot)
		bonsaiPot.potSetup("bonsaiPot")
		SignalBus.removeGold.emit(shopPrices["bonsai_pot"])
		Global.itemCost = shopPrices["bonsai_pot"]



func _on_mystery_seed_tier_1_button_pressed():
	if Global.gold >= shopPrices["mystery_seed_tier_1"]:
		SignalBus.removeGold.emit(shopPrices["mystery_seed_tier_1"])
		SignalBus.generateMysterySeed.emit(1)


func _on_small_pot_mouse_entered():
	SignalBus.shopDescription.emit("Small Pot", "Grows plants with small roots", 5)


func _on_medium_pot_mouse_entered():
	SignalBus.shopDescription.emit("Medium Pot", "Grows plants with medium/small roots", 10)


func _on_bonsai_pot_mouse_entered():
	SignalBus.shopDescription.emit("Bonsai Pot", "Grows plants with bonsai/small roots", 10)


func _on_mystery_seed_tier_1_button_mouse_entered():
	SignalBus.shopDescription.emit("Mystery Seed Lv.1", "Get a random tier 1 seed", 25)


func _on_small_pot_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_medium_pot_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_bonsai_pot_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_mystery_seed_tier_1_button_mouse_exited():
	SignalBus.hideShopDesciption.emit()
