extends Control
@onready var flower_container = $Background/MarginContainer/HBoxContainer/PlantStatContainer/ScrollContainer/MarginContainer/FlowerContainer
@onready var stem_container = $Background/MarginContainer/HBoxContainer/PlantStatContainer/ScrollContainer2/MarginContainer/StemContainer
@onready var achievement_container = $Background/MarginContainer/HBoxContainer/VBoxContainer3/ScrollContainer2/MarginContainer/achievementContainer


@onready var gold_earned = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/GoldEarned
@onready var xp_earned = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/XPEarned
@onready var seeds_planted = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/SeedsPlanted
@onready var flowers_harvested = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/FlowersHarvested
@onready var seeds_harvested = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/SeedsHarvested
@onready var seeds_sold = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/SeedsSold
@onready var water_usage = $"Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/Water Usage"
@onready var world_lifetime = $Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/WorldLifetime
@onready var in_game_time = $"Background/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/In-gameTime"

var savePath = "user://saveStats.tres"

var achievementConditions = {"pansyStem": 5,"poppyStem": 5,"cactusStem": 5,"bleedingheartStem": 5,"chiveStem": 5,
"tulipStem": 5,"sunflowerStem":5,"tomatoStem": 5,"pepperStem": 5,
"pansyFlower": 100, "poppyFlower": 100, "cactusFlower": 100, "bleedingheartFlower": 100,"chiveFlower": 100, "tulipFlower": 100, "sunflowerFlower": 100, 
"tomatoFlower": 100, "pepperFlower":100}
var achieved = []
var active = []
var inactive = ["pansyStem","poppyStem","cactusStem","bleedingheartStem","chiveStem","tulipStem","sunflowerStem","tomatoStem","pepperStem","pansyFlower", "poppyFlower",
 "cactusFlower", "bleedingheartFlower","chiveFlower", "tulipFlower", "sunflowerFlower", "tomatoFlower", "pepperFlower"]

var stemDict = {"pansyStem": 0,"poppyStem": 0,"cactusStem": 0,"bleedingheartStem": 0,"chiveStem": 0,"tulipStem": 0,"sunflowerStem": 0,"tomatoStem": 0,"pepperStem": 0}
var flowerDict = { "pansyFlower": 0, "poppyFlower": 0, "cactusFlower": 0, "bleedingheartFlower": 0,"chiveFlower": 0, "tulipFlower": 0, "sunflowerFlower": 0, 
"tomatoFlower": 0, "pepperFlower": 0}
var goldEarned:int = 0
var XPEarned:int = 0
var seedsPlanted:int = 0
var flowersHarvested:int= 0
var seedsHarvested:int= 0
var seedsSold:int= 0
var plantsSold:int= 0
var waterUsage:float= 0
var worldLifetime:int= 0
var inGameTime:int= 0
var worldTimeStart = null
var sessionTimeStart = null

func _ready():
	SignalBus.addGold.connect(updateGold)
	SignalBus.gainXP.connect(updateXP)
	SignalBus.waterUsed.connect(updateWaterUsed)
	SignalBus.flowerHarvested.connect(updateFlowersHarvested)
	SignalBus.seedHarvested.connect(updateSeedsHarvested)
	SignalBus.seedPlanted.connect(updateSeedsPlanted)
	SignalBus.seedSold.connect(updateSeedsSold)
	SignalBus.newSaveGame.connect(newSaveGame)
	SignalBus.saveGame.connect(saveGame)
	SignalBus.loadGame.connect(loadGame)
	SignalBus.updateTimeStats.connect(updateWorldTime)
	SignalBus.updateTimeStats.connect(updateGameTime)
	SignalBus.addFlowerStat.connect(flowerStatUpdate)
	SignalBus.addStemStat.connect(stemStatUpdate)

func updateGold(value:int):
	goldEarned += value
	gold_earned.text = "Gold Earned: " + str(goldEarned)

func updateXP(value:int):
	XPEarned += value
	xp_earned.text = "XP Earned: " + str(XPEarned)

func updateFlowersHarvested(value:int):
	flowersHarvested += value
	flowers_harvested.text = "Flowers Harvested: " + str(flowersHarvested)

func updateSeedsHarvested(value:int):
	seedsHarvested += value
	seeds_harvested.text = "Seeds Harvested: " + str(seedsHarvested)

func updateSeedsPlanted(value:int):
	seedsPlanted += value
	seeds_planted.text = "Seeds Planted: " + str(seedsPlanted)

func updateSeedsSold(value:int):
	seedsSold += value
	seeds_sold.text = "Seeds Sold: " + str(seedsSold)

func updateWaterUsed(value:float):
	waterUsage += value
	water_usage.text = "Water Used: " + str(int(waterUsage)) + " L"

func updateWorldTime():
	if worldTimeStart == null:
		setWorldTimeStart()
	worldLifetime = Time.get_unix_time_from_system() - worldTimeStart
	if worldLifetime < 60:
		world_lifetime.text = "World Time: "+ str(worldLifetime) + " secs"
	elif worldLifetime < 3600:
		world_lifetime.text = "World Time: "+str(worldLifetime/60) + " mins"
	elif worldLifetime < 86400:
		world_lifetime.text = "World Time: "+str(worldLifetime/3600) + " hours"
	else:
		world_lifetime.text = "World Time: "+str(worldLifetime/86400) + " days"

func updateGameTime():
	inGameTime += Time.get_unix_time_from_system() - sessionTimeStart
	setSessionTimeStart()
	if inGameTime < 60:
		in_game_time.text = "In-Game time: "+ str(inGameTime) + " secs"
	elif inGameTime < 3600:
		in_game_time.text = "In-Game time: "+ str(inGameTime/60) + " mins"
	elif inGameTime < 86400:
		in_game_time.text = "In-Game time: "+ str(inGameTime/3600) + " hours"
	else:
		in_game_time.text = "In-Game time: "+ str(inGameTime/86400) + " days"

func achievementUpdate(value:String, type:String):
	for child in achievement_container.get_children():
		if child.name == value:
			var inactiveIndex = inactive.find(value)
			if  inactiveIndex != -1:
				inactive.pop_at(inactiveIndex)
				active.append(value)
				child.setActive()
			var activeIndex = active.find(value)
			if  activeIndex != -1:
				if type == "Stem":
					child.setProgress((float(stemDict[value])/ float(achievementConditions[value]))*100.00)
					if float(stemDict[value])/ float(achievementConditions[value]) >= 1.00:
						child.setComplete()
						active.pop_at(activeIndex)
						achieved.append(value)
				elif type == "Flower":
					child.setProgress((float(flowerDict[value])/ float(achievementConditions[value]))*100.00)
					if float(flowerDict[value])/ float(achievementConditions[value]) >= 1.00:
						child.setComplete()
						active.pop_at(activeIndex)
						achieved.append(value)



func setWorldTimeStart():
	worldTimeStart = Time.get_unix_time_from_system()

func setSessionTimeStart():
	sessionTimeStart = Time.get_unix_time_from_system()

const FLOWER_COMPONENT_STAT = preload("res://Scenes/flower_component_stat.tscn")
func flowerStatUpdate(value:String):
	flowerDict[value] += 1
	var itemFound = false
	for child in flower_container.get_children():
		if child.name == value:
			itemFound = true
			child.setCount(flowerDict[value])
	if !itemFound:
		var plantFrame = FLOWER_COMPONENT_STAT.instantiate()
		flower_container.add_child(plantFrame)
		plantFrame.name = value
		plantFrame.setImage(value)
		plantFrame.setCount(flowerDict[value])
	achievementUpdate(value,"Flower")

const STEM_COMPONENT_STAT = preload("res://Scenes/stem_component_stat.tscn")
func stemStatUpdate(value:String):
	stemDict[value] += 1
	var itemFound = false
	for child in stem_container.get_children():
		if child.name == value:
			itemFound = true
			child.setCount(stemDict[value])
	if !itemFound:
		var plantFrame = STEM_COMPONENT_STAT.instantiate()
		stem_container.add_child(plantFrame)
		plantFrame.name = value
		plantFrame.setImage(value)
		plantFrame.setCount(stemDict[value])
	achievementUpdate(value,"Stem")

func loadFlowerDict():
	for key in flowerDict.keys():
		if flowerDict[key] > 0:
			var plantFrame = FLOWER_COMPONENT_STAT.instantiate()
			flower_container.add_child(plantFrame)
			plantFrame.name = key
			plantFrame.setImage(key)
			plantFrame.setCount(flowerDict[key])

func loatStemDict():
	for key in stemDict.keys():
		if stemDict[key] > 0:
			var plantFrame = STEM_COMPONENT_STAT.instantiate()
			stem_container.add_child(plantFrame)
			plantFrame.name = key
			plantFrame.setImage(key)
			plantFrame.setCount(stemDict[key])

func loadAchievements():
	for child in achievement_container.get_children():
		child.setUnknown()
		child.setup(child.name)
		if achieved.find(child.name) != -1:
			child.setComplete()
		elif active.find(child.name) != -1:
			child.setActive()
			if flowerDict.has(child.name):
				print_debug(child.name)
				achievementUpdate(child.name,"Flower")
			elif stemDict.has(child.name):
				achievementUpdate(child.name,"Stem")
	
	



func saveGame():
	updateGameTime()
	var savedGame = gameStats.new()
	savedGame.goldEarned = goldEarned
	savedGame.XPEarned = XPEarned
	savedGame.worldTimeStart = str(worldTimeStart)
	savedGame.flowersHarvested = flowersHarvested
	savedGame.seedsHarvested = seedsHarvested
	savedGame.seedsPlanted = seedsPlanted
	savedGame.seedsSold = seedsSold
	savedGame.waterUsed = waterUsage
	savedGame.inGameTime = inGameTime
	savedGame.flowerDict = flowerDict
	savedGame.stemDict = stemDict
	savedGame.achieved = achieved
	savedGame.inactive = inactive
	savedGame.active = active
	ResourceSaver.save(savedGame, savePath)

func loadGame():
	if not FileAccess.file_exists(savePath):
		print_debug("No save file/ file is corrupted! making fresh saveFile (stats)")
		newSaveGame()
		return
	var savedGame:gameStats = load(savePath) as gameStats
	setSessionTimeStart()
	updateGold(savedGame.goldEarned)
	updateFlowersHarvested(savedGame.flowersHarvested)
	updateSeedsHarvested(savedGame.seedsHarvested)
	updateSeedsPlanted(savedGame.seedsPlanted)
	updateSeedsSold(savedGame.seedsSold)
	updateWaterUsed(savedGame.waterUsed)
	updateXP(savedGame.XPEarned)
	flowerDict = savedGame.flowerDict
	stemDict = savedGame.stemDict
	loadFlowerDict()
	loatStemDict()
	achieved = savedGame.achieved
	inactive = savedGame.inactive
	active = savedGame.active
	loadAchievements()
	inGameTime = savedGame.inGameTime
	worldTimeStart = float(savedGame.worldTimeStart)


func newSaveGame():
	goldEarned = 0
	XPEarned = 0
	seedsPlanted = 0
	flowersHarvested= 0
	seedsHarvested= 0
	seedsSold= 0
	plantsSold= 0
	waterUsage= 0
	worldLifetime= 0
	inGameTime= 0
	stemDict = {"pansyStem": 0,"poppyStem": 0,"cactusStem": 0,"bleedingheartStem": 0,"chiveStem": 0,"tulipStem": 0,"sunflowerStem": 0,"tomatoStem": 0,"pepperStem": 0}
	flowerDict = { "pansyFlower": 0, "poppyFlower": 0, "cactusFlower": 0, "bleedingheartFlower": 0,"chiveFlower": 0, "tulipFlower": 0, "sunflowerFlower": 0, 
"tomatoFlower": 0, "pepperFlower": 0}
	achieved = []
	active = []
	inactive = ["pansyStem","poppyStem","cactusStem","bleedingheartStem","chiveStem","tulipStem","sunflowerStem","tomatoStem","pepperStem","pansyFlower", "poppyFlower",
 "cactusFlower", "bleedingheartFlower","chiveFlower", "tulipFlower", "sunflowerFlower", "tomatoFlower", "pepperFlower"]	
	for child in stem_container.get_children():
		child.queue_free()
	for child in flower_container.get_children():
		child.queue_free()

	setWorldTimeStart()
	setSessionTimeStart()
	saveGame()
	loadGame()
