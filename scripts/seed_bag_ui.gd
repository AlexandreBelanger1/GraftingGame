extends Control
@onready var grid_container = $Background/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var pickup = $Pickup



const SEED_INVENTORY_SLOT = preload("res://Scenes/seed_inventory_slot.tscn")
var potSizes = {0: "smallRoots", 1: "mediumRoots", 2: "bonsaiRoots"}
var RNG = RandomNumberGenerator.new()
var savePath = "user://savegameSeeds.tres"

func _ready():
	SignalBus.collectSeed.connect(addSeed)
	SignalBus.generateMysterySeed.connect(generateMysterySeed)
	SignalBus.saveGame.connect(save)
	SignalBus.loadGame.connect(loadSave)
	SignalBus.newSaveGame.connect(newSave)
	SignalBus.generateSeed.connect(generateSeed)

func addSeed(roots:String,stem:String,flower:String, plantSpecialType:String):
	pickup.play()
	var slot = SEED_INVENTORY_SLOT.instantiate()
	grid_container.add_child(slot)
	slot.setSeed(roots,stem,flower,plantSpecialType)

func generateMysterySeed(tier: int):
	var rand 
	var rootSize
	rand = int(RNG.randf_range(0,2.99))
	rootSize = potSizes[rand]
	if tier == 1:
		rand = int(RNG.randf_range(0, Global.tier1Seeds.size()-0.01))
		addSeed(rootSize, Global.tier1Seeds[rand]+"Stem",Global.tier1Seeds[rand]+"Flower", "none")

func generateSeed(seed:String):
	if seed == "cactus":
		addSeed("smallRoots", "cactusStem","cactusFlower", "none")
	if seed == "pansy":
		addSeed("mediumRoots", "pansyStem","pansyFlower", "none")
	if seed == "pepper":
		addSeed("mediumRoots", "pepperStem","pepperFlower", "none")
	if seed == "chive":
		addSeed("mediumRoots", "chiveStem","chiveFlower", "none")
	if seed == "poppy":
		addSeed("mediumRoots", "poppyStem","poppyFlower", "none")
	if seed == "bleedingheart":
		addSeed("mediumRoots", "bleedingheartStem","bleedingheartFlower", "none")
	if seed == "sunflower":
		addSeed("mediumRoots", "sunflowerStem","sunflowerFlower", "none")
	if seed == "tulip":
		addSeed("mediumRoots", "tulipStem","tulipFlower", "none")
	if seed == "tomato":
		addSeed("mediumRoots", "tomatoStem","tomatoFlower", "none")

func save():
	var savedGame = saveFile.new()
	for child in grid_container.get_children():
		savedGame.seedsArray.append(child.saveSeed())
	ResourceSaver.save(savedGame, savePath)
	print_debug("saving seeds")

func loadSave():
	if not FileAccess.file_exists(savePath):
		print_debug("No save file/ file is corrupted! Creating new seed save file")
		newSave()
		return
	print_debug("loading seeds")
	var savedGame:saveFile = load(savePath) as saveFile
	for child in grid_container.get_children():
		child.queue_free()
	for data in savedGame.seedsArray:
		addSeed(data.rootType,data.stemType,data.flowerType,data.plantSpecialType)

func newSave():
	var savedGame = saveFile.new()
	ResourceSaver.save(savedGame, savePath)
	loadSave()


func _on_texture_rect_pressed():
	for child in grid_container.get_children():
		child.queue_free()
		SignalBus.addGold.emit(1)
		SignalBus.seedSold.emit(1)
