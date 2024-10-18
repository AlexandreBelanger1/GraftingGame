extends Control
@onready var progress_bar = $ProgressBar
@onready var label = $ColorRect/Label

var level = 1
var levelThreshhold = [0,1000,5000,10000,20000,35000,50000,90000,150000,250000,500000,1000000,1500000,3000000,5000000,10000000]
var savePath = "user://saveLevel.tres"

func _ready():
	SignalBus.gainXP.connect(gainXP)
	SignalBus.saveGame.connect(saveGame)
	SignalBus.loadGame.connect(loadGame)
	SignalBus.newSaveGame.connect(newSaveGame)

func gainXP(value:int):
	progress_bar.value += value
	if progress_bar.value >= progress_bar.max_value:
		levelUP()


func levelUP():
	progress_bar.value = 0
	if level < levelThreshhold.size()-1:
		print_debug(levelThreshhold.size()-1)
		level += 1
		label.text = str(level)
		progress_bar.max_value = levelThreshhold[level]
		SignalBus.setGardenLevel.emit(level,false)

func newSaveGame():
	var savedGame = levelSave.new()
	savedGame.level = 1
	savedGame.progress = 0
	ResourceSaver.save(savedGame, savePath)
	loadGame()

func saveGame():
	var savedGame = levelSave.new()
	savedGame.level = level
	savedGame.progress = progress_bar.value
	ResourceSaver.save(savedGame, savePath)

func loadGame():
	if not FileAccess.file_exists(savePath):
		print_debug("No save file/ file is corrupted! making fresh saveFile (garden level)")
		newSaveGame()
		return
	var savedGame:levelSave = load(savePath) as levelSave
	level = savedGame.level
	label.text = str(level)
	progress_bar.max_value = levelThreshhold[level]
	progress_bar.value = savedGame.progress
	SignalBus.setGardenLevel.emit(level,true)
