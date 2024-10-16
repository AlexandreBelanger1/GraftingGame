extends Control
@onready var button_hover = $ButtonHover

#POTS
@onready var small_pot = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/smallPot
@onready var medium_pot = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/mediumPot
@onready var bonsai_pot = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/bonsaiPot
#MACHINES
@onready var mutation_rod = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/mutationRod
@onready var apiary = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/Apiary
@onready var greenhouse = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/Greenhouse
#SEEDS
@onready var cactus_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/cactusSeed
@onready var pansy_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/pansySeed
@onready var poppy_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/poppySeed
@onready var tulip_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/tulipSeed
@onready var tomato_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/tomatoSeed
@onready var pepper_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/pepperSeed
@onready var bleedingheart_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/bleedingheartSeed
@onready var sunflower_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/sunflowerSeed
@onready var chive_seed = $Background/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer/chiveSeed





var shopPrices ={"medium_pot": 10,"small_pot": 5, "bonsai_pot": 10, "mystery_seed_tier_1": 25, "Mutation_Machine": 500, "Apiary": 1000, "Greenhouse": 5,
"cactusSeed": 3, "pansySeed": 3, "poppySeed": 3, "sunflowerSeed": 3,"pepperSeed": 3,"tomatoSeed": 3,"chiveSeed": 3,"bleedingheartSeed": 3,"tulipSeed": 3}

func _ready():
	SignalBus.setGardenLevel.connect(setLevel)


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

func _on_cactus_seed_pressed():
	if Global.gold >= shopPrices["cactusSeed"]:
		SignalBus.removeGold.emit(shopPrices["cactusSeed"])
		SignalBus.generateSeed.emit("cactus")

func _on_pansy_seed_pressed():
	if Global.gold >= shopPrices["pansySeed"]:
		SignalBus.removeGold.emit(shopPrices["pansySeed"])
		SignalBus.generateSeed.emit("pansy")


func _on_poppy_seed_pressed():
	if Global.gold >= shopPrices["poppySeed"]:
		SignalBus.removeGold.emit(shopPrices["poppySeed"])
		SignalBus.generateSeed.emit("poppy")


func _on_tulip_seed_pressed():
	if Global.gold >= shopPrices["tulipSeed"]:
		SignalBus.removeGold.emit(shopPrices["tulipSeed"])
		SignalBus.generateSeed.emit("tulip")


func _on_tomato_seed_pressed():
	if Global.gold >= shopPrices["tomatoSeed"]:
		SignalBus.removeGold.emit(shopPrices["tomatoSeed"])
		SignalBus.generateSeed.emit("tomato")


func _on_pepper_seed_pressed():
	if Global.gold >= shopPrices["pepperSeed"]:
		SignalBus.removeGold.emit(shopPrices["pepperSeed"])
		SignalBus.generateSeed.emit("pepper")


func _on_bleedingheart_seed_pressed():
	if Global.gold >= shopPrices["bleedingheartSeed"]:
		SignalBus.removeGold.emit(shopPrices["bleedingheartSeed"])
		SignalBus.generateSeed.emit("bleedingheart")


func _on_sunflower_seed_pressed():
	if Global.gold >= shopPrices["sunflowerSeed"]:
		SignalBus.removeGold.emit(shopPrices["sunflowerSeed"])
		SignalBus.generateSeed.emit("sunflower")


func _on_chive_seed_pressed():
	if Global.gold >= shopPrices["chiveSeed"]:
		SignalBus.removeGold.emit(shopPrices["chiveSeed"])
		SignalBus.generateSeed.emit("chive")

#Hovering descriptions
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

func _on_cactus_seed_mouse_entered():
	SignalBus.shopDescription.emit("Cactus Seed", "Grows a cactus", 3)
	button_hover.play()

func _on_pansy_seed_mouse_entered():
	SignalBus.shopDescription.emit("Pansy Seed", "Grows Pansies", 3)
	button_hover.play()


func _on_poppy_seed_mouse_entered():
	SignalBus.shopDescription.emit("Poppy Seed", "Grows a Poppy", 3)
	button_hover.play()


func _on_tulip_seed_mouse_entered():
	SignalBus.shopDescription.emit("Tulip Seed", "Grows a Tulip", 3)
	button_hover.play()


func _on_tomato_seed_mouse_entered():
	SignalBus.shopDescription.emit("Tomato Seed", "Grows Tomatoes", 3)
	button_hover.play()


func _on_pepper_seed_mouse_entered():
	SignalBus.shopDescription.emit("Pepper Seed", "Grows Peppers", 3)
	button_hover.play()


func _on_bleedingheart_seed_mouse_entered():
	SignalBus.shopDescription.emit("Bleedingheart Seed", "Grows a Bleedingheart", 3)
	button_hover.play()


func _on_sunflower_seed_mouse_entered():
	SignalBus.shopDescription.emit("Sunflower Seed", "Grows a Sunflower", 3)
	button_hover.play()


func _on_chive_seed_mouse_entered():
	SignalBus.shopDescription.emit("Chive Seed", "Grows Chives", 3)
	button_hover.play()

func hideDescription():
	SignalBus.hideShopDesciption.emit()

func setLevel(level:int, load:bool):
	hideItems()
	if level >=5:
		apiary.visible = true
		pepper_seed.visible = true
	if level >=4:
		greenhouse.visible = true
		bleedingheart_seed.visible = true
	if level >=3:
		mutation_rod.visible = true
		tomato_seed.visible = true
		chive_seed.visible = true
	if level >=2:
		bonsai_pot.visible = true
		sunflower_seed.visible = true
		poppy_seed.visible = true
	if level >=1:
		small_pot.visible = true
		medium_pot.visible = true
		cactus_seed.visible = true
		pansy_seed.visible = true

func hideItems():
	apiary.visible = false
	pepper_seed.visible = false
	greenhouse.visible = false
	bleedingheart_seed.visible = false
	mutation_rod.visible = false
	tomato_seed.visible = false
	chive_seed.visible = false
	bonsai_pot.visible = false
	sunflower_seed.visible = false
	poppy_seed.visible = false
	small_pot.visible = false
	medium_pot.visible = false
	cactus_seed.visible = false
	pansy_seed.visible = false
