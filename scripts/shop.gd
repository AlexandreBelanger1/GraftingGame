extends Control
@onready var button_hover = $ButtonHover

var shopPrices ={"medium_pot": 10,"small_pot": 5, "bonsai_pot": 10, "mystery_seed_tier_1": 25, "Mutation_Machine": 500, "Apiary": 1000, "Greenhouse": 5}

const SMALL_POT = preload("res://Scenes/Pots/SmallPot.tscn")
func _on_small_pot_pressed():
	if Global.gold >= shopPrices["small_pot"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
		Global.is_dragging = true
		Global.placingItem = true
		var smallPot = SMALL_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(smallPot)
		smallPot.potSetup("smallPot")
		SignalBus.removeGold.emit(shopPrices["small_pot"])
		Global.itemCost = shopPrices["small_pot"]


const MEDIUM_POT = preload("res://Scenes/Pots/MediumPot.tscn")
func _on_medium_pot_pressed():
	if Global.gold >= shopPrices["medium_pot"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
		Global.is_dragging = true
		Global.placingItem = true
		var medPot = MEDIUM_POT.instantiate()
		get_parent().get_parent().get_parent().add_child(medPot)
		medPot.potSetup("mediumPot")
		SignalBus.removeGold.emit(shopPrices["medium_pot"])
		Global.itemCost = shopPrices["medium_pot"]


const BONSAI_POT = preload("res://Scenes/Pots/BonsaiPot.tscn")
func _on_bonsai_pot_pressed():
	if Global.gold >= shopPrices["bonsai_pot"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
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

const MUTATION_MACHINE = preload("res://Scenes/Machines/mutation_machine.tscn")
func _on_mutation_rod_pressed():
	if Global.gold >= shopPrices["Mutation_Machine"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
		Global.is_dragging = true
		Global.placingItem = true
		var mutationMachine = MUTATION_MACHINE.instantiate()
		get_parent().get_parent().get_parent().add_child(mutationMachine)
		mutationMachine.setup()
		SignalBus.removeGold.emit(shopPrices["Mutation_Machine"])
		Global.itemCost = shopPrices["Mutation_Machine"]

const APIARY = preload("res://Scenes/Machines/apiary.tscn")
func _on_apiary_pressed():
	if Global.gold >= shopPrices["Apiary"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
		Global.is_dragging = true
		Global.placingItem = true
		var apiary = APIARY.instantiate()
		get_parent().get_parent().get_parent().add_child(apiary)
		apiary.setup()
		SignalBus.removeGold.emit(shopPrices["Apiary"])
		Global.itemCost = shopPrices["Apiary"]

const GREENHOUSE = preload("res://Scenes/Machines/greenhouse.tscn")
func _on_greenhouse_pressed():
	if Global.gold >= shopPrices["Greenhouse"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
		Global.is_dragging = true
		Global.placingItem = true
		var greenhouse = GREENHOUSE.instantiate()
		get_parent().get_parent().get_parent().add_child(greenhouse)
		greenhouse.setup()
		SignalBus.removeGold.emit(shopPrices["Greenhouse"])
		Global.itemCost = shopPrices["Greenhouse"]

func _on_small_pot_mouse_entered():
	SignalBus.shopDescription.emit("Small Pot", "Grows plants with small roots", 5)
	button_hover.play()


func _on_medium_pot_mouse_entered():
	SignalBus.shopDescription.emit("Medium Pot", "Grows plants with medium/small roots", 10)
	button_hover.play()


func _on_bonsai_pot_mouse_entered():
	SignalBus.shopDescription.emit("Bonsai Pot", "Grows plants with bonsai/small roots", 10)
	button_hover.play()


func _on_mystery_seed_tier_1_button_mouse_entered():
	SignalBus.shopDescription.emit("Mystery Seed Lv.1", "Get a random tier 1 seed", 25)
	button_hover.play()

func _on_mutation_rod_mouse_entered():
	SignalBus.shopDescription.emit("Mutation Machine", "Nearby plants more likely to create special seeds", 500)
	button_hover.play()

func _on_apiary_mouse_entered():
	SignalBus.shopDescription.emit("Apiary", "Nearby plants produce more seeds, produces honey", 1500)
	button_hover.play()


func _on_greenhouse_mouse_entered():
	SignalBus.shopDescription.emit("Greenhouse", "Internal plants flower faster", 2500)
	button_hover.play()

func _on_small_pot_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_medium_pot_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_bonsai_pot_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_mystery_seed_tier_1_button_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_mutation_rod_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_apiary_mouse_exited():
	SignalBus.hideShopDesciption.emit()

func _on_greenhouse_mouse_exited():
	SignalBus.hideShopDesciption.emit()



