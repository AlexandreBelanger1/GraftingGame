class_name plant extends StaticBody2D
@onready var roots = $Roots
@onready var stem = $stem
@onready var water_bar = $WaterBar
@onready var water_consumption = $WaterConsumption
@onready var plant_options = $PlantOptions
@onready var xp_timer = $xpTimer


var waterLevel = 0.00
var waterCapacity = 43200
var waterConsumptionRate = 2000
var xpGain = 1

const FLOWER = preload("res://Scenes/flowers/flower.tscn")
var plantSpecialType = "none"
var flowers = []
var productionRate
var sellValue
var flowerType
var rootType
var stemType
var stemComplete = false
var flowerComplete = false
var fStats = flowerStats.new()
var flowerModifiers = {"FlowerGrowthRate": 1}
var stemModifiers = {"StemGrowthRate": 1}

func _ready():
	SignalBus.waterBarEnable.connect(waterBarEnable)
	SignalBus.changeGameSpeed.connect(adjustTimeVariables)
	SignalBus.plantOptions.connect(enablePlantOptions)

func setup():
	adjustTimeVariables()
	var seed = Global.selectedSeed
	if seed != null:
		roots.setup(seed.getSeed("roots"))
		checkRootSize()
		stem.setup(seed.getSeed("stem"))
		flowerType = seed.getSeed("flower")
		rootType = seed.getSeed("roots")
		stemType = seed.getSeed("stem")
		plantSpecialType = seed.getSeed("specialType")
		configureStats()
	else:
		queue_free()

func loadPlant(data:potData):
	flowerComplete  = data.flowerComplete
	stemComplete = data.stemComplete
	flowerType = data.plantFlower
	rootType = data.plantRoots
	plantSpecialType = data.plantSpecialType
	if rootType == "pansyRoots":
		rootType = "mediumRoots"
	if rootType == "sunflowerRoots":
		rootType = "mediumRoots"
	if rootType == "cactusRoots":
		rootType = "smallRoots"
	stemType = data.plantStem
	roots.loadRoots(data)
	stem.loadStem(data)
	adjustTimeVariables()
	waterLevel = data.waterSeconds
	if waterLevel > 0:
		water_consumption.start()
	if data.stemComplete:
		for i in stem.stats.flowerCount:
			var flower = FLOWER.instantiate()
			add_child(flower)
			flowers.append(flower)
			flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
			flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
			if data.flowerComplete:
				flower.setComplete(data.plantFlower,flowerModifiers)
				waterLevel = data.waterSeconds
				water_bar.value = waterLevel
				xp_timer.start()
			else:
				flower.setup(flowerType,flowerModifiers)
				flower.setFrame(data.flowerFrame)
				flower.growWhileAway(data.waterSeconds, Time.get_unix_time_from_system() - Global.lastSaveTime)
		
	configureStats()
	

func revealRoots(value: bool):
	roots.revealRoots(value)

func checkRootSize():
	var potSize = get_parent().stats.size
	var potType = get_parent().stats.specialType
	var rootType = roots.stats.specialType
	if potSize < roots.stats.size:
		SignalBus.mouseTooltip.emit("","", "None", "None", "A different pot is required!", true, true)
		queue_free()
	# rootType 0 is for non-special pot requirements
	elif rootType != 0:
		if rootType != potType:
			SignalBus.mouseTooltip.emit("","", "None", "None", "A different pot is required!", true, true)
			queue_free()
		else:
			Global.selectedSeed.queue_free()
	else:
		Global.selectedSeed.queue_free()

func _on_stem_stem_complete():
	for i in stem.stats.flowerCount:
		var flower = FLOWER.instantiate()
		add_child(flower)
		flowers.append(flower)
		flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
		flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
		flower.setup(flowerType,flowerModifiers)
	if stem.stats.flowerCount == 0:
		flowerComplete = true
	stemComplete = true

func save(index:int):
	if index == 1:
		return stemComplete
	elif index == 2:
		return flowerComplete
	elif index == 3:
		return rootType
	elif index == 4:
		return stemType
	elif index == 5:
		return flowerType
	elif index == 6:
		return plantSpecialType
	elif index == 7:
		return stem.getStat(7)
	elif index == 8:
		if stemComplete:
			return flowers[0].getStat(5)
		else: 
			return 0
	elif index == 9:
		return waterLevel

func getTooltip(index: int):
	if index == 1:
		return flowerType.trim_suffix("Flower") + " / " + stemType.trim_suffix("Stem")
	elif index == 2:
		return float(stem.getGrowthFrame()) / float(stem.stats.growthFrames)
	elif index == 3:
		return 5.00
		#if stemComplete and stem.stats.flowerCount != 0:
			#if flowers[0] != null:
				#return 5.00
				##return flowers[0].getGrowthPercent()
		#else:
			#return 0.00
	elif index == 4:
		return stem.getStat(1)
	elif index == 5:
		return fStats.growthRate
	elif index == 6:
		return productionRate
	elif index == 7:
		return sellValue
	elif index == 8:
		return flowerComplete

func configureStats():
	fStats = load(Global.flowerStatsDict[flowerType])
	productionRate = stem.getStat(2) + (stem.getStat(5) * fStats.productionRate)
	sellValue = stem.getStat(6) + (stem.getStat(5) * fStats.sellValue)
	specialTypeSetup()

func setFlowersComplete():
	flowerComplete = true
	xp_timer.start()

func shake():
	for flower in flowers:
		flower.shakeFlower()

func getComponent(value:int):
	if value == 1:
		return rootType
	elif value == 2:
		return stemType
	elif value == 3:
		return flowerType

const SPECIAL_TYPE_EFFECTS = preload("res://Scenes/specialTypes/special_type_effects.tscn")
func specialTypeSetup():
	if plantSpecialType != "none":
		var specialEffects = SPECIAL_TYPE_EFFECTS.instantiate()
		add_child(specialEffects)
		specialEffects.start(plantSpecialType)


func sellFlowers():
	for i in flowers:
		if flowerComplete:
			SignalBus.addGold.emit(load(Global.flowerStatsDict[flowerType]).sellValue)
		i.queue_free()
	restartFlowerGrowth()
	flowerComplete = false
	xp_timer.stop()

func restartFlowerGrowth():
	var index = 0
	for i in stem.stats.flowerCount:
		var flower = FLOWER.instantiate()
		add_child(flower)
		flowers[index]= flower
		flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
		flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
		flower.setup(flowerType,flowerModifiers)
		index += 1

func waterBarEnable(enabled:bool):
	water_bar.visible = enabled
	water_bar.value = waterLevel

func addWater():
	water_consumption.start()
	if waterLevel < waterCapacity:
		waterLevel += 500
		if waterLevel > waterCapacity:
			waterLevel = waterCapacity
		water_bar.value = waterLevel



func _on_stem_grow_flowers_while_away(waterSeconds, deltaTime):
	for i in stem.stats.flowerCount:
			var flower = FLOWER.instantiate()
			add_child(flower)
			flowers.append(flower)
			flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
			flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
			flower.setup(flowerType,flowerModifiers)
			flower.growWhileAway(waterSeconds,deltaTime)




func _on_stem_set_water_level(waterLevelValue):
	waterLevel = waterLevelValue
	water_bar.value = waterLevel

func setWaterLevel(waterLevelValue):
	waterLevel = waterLevelValue
	water_bar.value = waterLevel

func getWaterLevel():
	return waterLevel

func loseWater(waterLost):
	waterLevel -= waterLost
	if waterLevel < 0.00:
		waterLevel = 0.00
	water_bar.value = waterLevel

func _on_stem_get_water_level():
	return waterLevel

func addModifier(type:String,magnitude:float):
	if type == "StemGrowthRate":
		stemModifiers["StemGrowthRate"] *= magnitude
		stem.refreshModifiers(stemModifiers)
	elif type == "FlowerGrowthRate":
		flowerModifiers["FlowerGrowthRate"] *= magnitude
		for i in flowers:
			i.refreshModifiers(flowerModifiers)


func removeModifier(type:String,magnitude:float):
	if type == "StemGrowthRate":
		stemModifiers["StemGrowthRate"] /= magnitude
		stem.refreshModifiers(stemModifiers)
	elif type == "FlowerGrowthRate":
		flowerModifiers["FlowerGrowthRate"] /= magnitude
		for i in flowers:
			i.refreshModifiers(flowerModifiers)



func adjustTimeVariables():
	water_consumption.wait_time = Global.gameSpeed * 10
	xpGain = (stem.getStat(2) + fStats.productionRate)*Global.gameSpeed

func _on_water_consumption_timeout():
	if waterLevel > 0:
		waterLevel -= waterConsumptionRate
		water_bar.value = waterLevel
	else:
		water_consumption.stop()

func enablePlantOptions(enabled:bool):
	if enabled:
		plant_options.visible = true
	else:
		plant_options.visible = false

func getPlantOptions():
	return plant_options.visible

func getFlowers():
	return flowers

func _on_xp_timer_timeout():
	SignalBus.gainXP.emit(xpGain)
