extends Node2D
@onready var player_ui = $CanvasLayer/PlayerUI
const BONSAI_POT = preload("res://Scenes/Pots/BonsaiPot.tscn")
const MEDIUM_POT = preload("res://Scenes/Pots/MediumPot.tscn")
const SMALL_POT = preload("res://Scenes/Pots/SmallPot.tscn")
@onready var seed_pouch_marker = $Camera2D/SeedPouchMarker
@onready var grid = $Grid

func _ready():
	windowSetup()
	Global.seedPouch = seed_pouch_marker
	SignalBus.addGold.connect(addCurrency)
	SignalBus.removeGold.connect(removeCurrency)
	SignalBus.loadGame.connect(load_game)
	SignalBus.saveGame.connect(save_game)
	SignalBus.newSaveGame.connect(new_save_game)
	SignalBus.gridToggle.connect(toggleGrid)
	if not FileAccess.file_exists("user://savegame.tres"):
		save_game()
	else:
		load_game()

func addCurrency(value: int):
	Global.gold += value
	player_ui.updateCurrency()

func removeCurrency(value: int):
	Global.gold -= value
	player_ui.updateCurrency()


func _on_plant_generate_gold():
	addCurrency(1)

func new_save_game():
	var savedGame = saveFile.new()
	savedGame.gold = 20
	ResourceSaver.save(savedGame, "user://savegame.tres")
	load_game()

func save_game():
	var savedGame = saveFile.new()
	for child in get_children():
		if child is pot:
			savedGame.potsArray.append(child.save())
	savedGame.gold = Global.gold
	ResourceSaver.save(savedGame, "user://savegame.tres")
	print_debug(savedGame.potsArray)

func load_game():
	if not FileAccess.file_exists("user://savegame.tres"):
		print_debug("No save file/ file is corrupted!")
		return
	print_debug("loading save")
	var savedGame:saveFile = load("user://savegame.tres") as saveFile
	for child in get_children():
		if child is pot:
			child.queue_free()
	for x in savedGame.potsArray:
		createPot(x)
	Global.gold = savedGame.gold
	if savedGame.gold == null:
		Global.gold = 20
	player_ui.updateCurrency()


func createPot(data:potData):
	var newPot 
	if data.potType == "smallPot":
		newPot = SMALL_POT.instantiate()
	elif data.potType == "mediumPot":
		newPot = MEDIUM_POT.instantiate()
	elif data.potType == "bonsaiPot":
		newPot = BONSAI_POT.instantiate()
	add_child(newPot)
	newPot.loadState(data)

func windowSetup():
	var taskbarHeight = DisplayServer.screen_get_size().y - DisplayServer.screen_get_usable_rect().size.y
	var width = DisplayServer.screen_get_usable_rect().size.x
	var height = int((400.00/1920.00)* DisplayServer.screen_get_usable_rect().size.x)
	get_window().size = Vector2i(width, height)
	print_debug(height)
	get_window().position.x = DisplayServer.screen_get_position().x
	get_window().position.y = DisplayServer.screen_get_position().y + (DisplayServer.screen_get_size().y - (height+ taskbarHeight))


func toggleGrid(value:bool):
	grid.visible = value
