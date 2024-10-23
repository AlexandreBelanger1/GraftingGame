extends Node2D
@onready var player_ui = $CanvasLayer/PlayerUI
@onready var get_gold = $GetGold
@onready var camera_2d = $Camera2D
@onready var music_player = $MusicPlayer


const BONSAI_POT = preload("res://Scenes/Pots/BonsaiPot.tscn")
const MEDIUM_POT = preload("res://Scenes/Pots/MediumPot.tscn")
const SMALL_POT = preload("res://Scenes/Pots/SmallPot.tscn")
@onready var seed_pouch_marker = $Camera2D/SeedPouchMarker
@onready var grid = $Grid
@onready var map_style = $MapStyle
#MAP STYLES
const BEACH = preload("res://Scenes/MapThemes/Beach.tscn")
const FLOATING_FARM = preload("res://Scenes/MapThemes/floating_farm_area.tscn")
const JAPANESE_HOUSE = preload("res://Scenes/MapThemes/japanese_house.tscn")
const VOID = preload("res://Scenes/MapThemes/void.tscn")
const SIMPLE = preload("res://Scenes/MapThemes/simple.tscn")

var savePath = "user://savegame.tres"
var themeName = "Simple"
var sfxVolume
var musicVolume

func _ready():
	windowSetup()
	Global.seedPouch = seed_pouch_marker
	SignalBus.addGold.connect(addCurrency)
	SignalBus.removeGold.connect(removeCurrency)
	SignalBus.loadGame.connect(load_game)
	SignalBus.saveGame.connect(save_game)
	SignalBus.newSaveGame.connect(new_save_game)
	SignalBus.gridToggle.connect(toggleGrid)
	SignalBus.windowSetup.connect(windowSetup)
	SignalBus.changeBackground.connect(setBackground)
	SignalBus.saveVolume.connect(setVolume)
	if not FileAccess.file_exists(savePath):
		SignalBus.saveGame.emit()
	else:
		SignalBus.loadGame.emit()
	music_player.start()

func addCurrency(value: int):
	Global.gold += value
	player_ui.updateCurrency()
	get_gold.play()

func removeCurrency(value: int):
	Global.gold -= value
	player_ui.updateCurrency()

func _on_plant_generate_gold():
	addCurrency(1)

func new_save_game():
	var savedGame = saveFile.new()
	savedGame.gold = 20
	ResourceSaver.save(savedGame, savePath)
	load_game()
	#createWateringCan(Vector2(180,0))
	createPot(Vector2(200,0))
	createPot(Vector2(300,0))
	createSeed(Vector2(200,50))
	createSeed(Vector2(300,50))
	save_game()

func save_game():
	var savedGame = saveFile.new()
	for child in get_children():
		if child is pot:
			savedGame.potsArray.append(child.save())
		if child is machine:
			savedGame.machineArray.append(child.save())
		if child is decoration:
			savedGame.decorationArray.append(child.save())
		if child is waterCan:
			savedGame.wateringCan = child.save()
	savedGame.gold = Global.gold
	savedGame.themeName = themeName
	savedGame.timeOfSave = str(Time.get_unix_time_from_system())
	savedGame.cameraUpgradeLeft = camera_2d.save(1)
	savedGame.cameraUpgradeRight = camera_2d.save(2)
	savedGame.musicVolume = str(musicVolume)
	savedGame.sfxVolume = str(sfxVolume)
	ResourceSaver.save(savedGame, savePath)
	print_debug(savedGame.potsArray)

func load_game():
	if not FileAccess.file_exists(savePath):
		print_debug("No save file/ file is corrupted!")
		new_save_game()
		return
	print_debug("loading save")
	var savedGame:saveFile = load(savePath) as saveFile
	for child in get_children():
		if child is pot:
			child.queue_free()
		if child is machine:
			child.queue_free()
		if child is decoration:
			child.queue_free()
		if child is waterCan:
			child.queue_free()
	Global.lastSaveTime = float(savedGame.timeOfSave)
	for x in savedGame.decorationArray:
		loadDecoration(x)
	for x in savedGame.machineArray:
		loadMachine(x)
	for x in savedGame.potsArray:
		loadPot(x)
	if savedGame.wateringCan != null:
		loadWaterCan(savedGame.wateringCan)
	else:
		createWateringCan(Vector2(350,78))
	camera_2d.load(1,savedGame.cameraUpgradeLeft)
	camera_2d.load(2,savedGame.cameraUpgradeRight)
	musicVolume = float(savedGame.musicVolume)
	sfxVolume = float(savedGame.sfxVolume)
	SignalBus.loadVolume.emit("Music",musicVolume)
	SignalBus.loadVolume.emit("SFX",sfxVolume)
	Global.gold = savedGame.gold
	setBackground(savedGame.themeName)
	player_ui.updateCurrency()


func loadPot(data:potData):
	var newPot 
	if data.potType == "smallPot":
		newPot = SMALL_POT.instantiate()
	elif data.potType == "mediumPot":
		newPot = MEDIUM_POT.instantiate()
	elif data.potType == "bonsaiPot":
		newPot = BONSAI_POT.instantiate()
	add_child(newPot)
	newPot.loadState(data)

const APIARY = preload("res://Scenes/Machines/apiary.tscn")
const GREENHOUSE = preload("res://Scenes/Machines/greenhouse.tscn")
const MUTATION_MACHINE = preload("res://Scenes/Machines/mutation_machine.tscn")
func loadMachine(data:machineData):
	var newMachine
	if data.machineType == "Greenhouse":
		newMachine = GREENHOUSE.instantiate()
	elif data.machineType == "Apiary":
		newMachine = APIARY.instantiate()
	elif data.machineType == "MutationMachine":
		newMachine = MUTATION_MACHINE.instantiate()
	if newMachine != null:
		add_child(newMachine)
		newMachine.global_position = data.position

const GODOT_PLUSHIE = preload("res://Scenes/Decorations/GodotPlushie.tscn")
func loadDecoration(data:decorationData):
	var newDecoration
	if data.decorationType == "GodotPlushie":
		newDecoration = GODOT_PLUSHIE.instantiate()
		newDecoration.setType("GodotPlushie")
	if newDecoration != null:
		add_child(newDecoration)
		newDecoration.global_position = data.position

func createPot(pos:Vector2):
	var newPot = MEDIUM_POT.instantiate()
	newPot.loadStats("res://Scenes/Pots/MediumPot.tres")
	add_child(newPot)
	newPot.setPotType("mediumPot")
	newPot.global_position = global_position+pos

const SEED = preload("res://Scenes/seed.tscn")
func createSeed(pos:Vector2):
	var newSeed = SEED.instantiate()
	add_child(newSeed)
	newSeed.global_position = global_position+pos


const WATERING_CAN = preload("res://Scenes/Machines/wateringCan.tscn")
func createWateringCan(pos:Vector2):
	var wateringCan = WATERING_CAN.instantiate()
	wateringCan.global_position = pos
	add_child(wateringCan)

func loadWaterCan(data:waterCanData):
	var wateringCan = WATERING_CAN.instantiate()
	add_child(wateringCan)
	wateringCan.loadState(data)

func windowSetup():
	var taskbarHeight = DisplayServer.screen_get_size().y - DisplayServer.screen_get_usable_rect().size.y
	var width = DisplayServer.screen_get_usable_rect().size.x
	var height = int((400.00/1920.00)* DisplayServer.screen_get_usable_rect().size.x)
	get_window().size = Vector2i(width, height)
	get_window().position.x = DisplayServer.screen_get_position().x
	get_window().position.y = DisplayServer.screen_get_position().y + (DisplayServer.screen_get_size().y - (height+ taskbarHeight))

func toggleGrid(value:bool):
	grid.visible = value

func setBackground(value:String):
	themeName = value
	var background
	for child in map_style.get_children():
		child.queue_free()
	if value == "Beach":
		background = BEACH.instantiate()
	elif value  == "Void":
		background = VOID.instantiate()
	elif value  == "FloatingFarm":
		background = FLOATING_FARM.instantiate()
	elif value  == "Japanese":
		background = JAPANESE_HOUSE.instantiate()
	elif value  == "Simple":
		background = SIMPLE.instantiate()
	map_style.add_child(background)
	background.global_position = Vector2(0,0)


func setVolume(Bus:String, value:float):
	if Bus == "SFX":
		sfxVolume = value
	elif Bus == "Music":
		musicVolume = value
