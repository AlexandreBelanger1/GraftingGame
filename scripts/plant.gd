class_name plant extends StaticBody2D
@onready var roots = $Roots
@onready var stem = $stem


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
func setup():
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
	if rootType == "pansyRoots":
		rootType = "mediumRoots"
	if rootType == "sunflowerRoots":
		rootType = "mediumRoots"
	if rootType == "cactusRoots":
		rootType = "smallRoots"
	stemType = data.plantStem
	roots.loadRoots(data)
	stem.loadStem(data)
	if data.flowerComplete:
		for i in stem.stats.flowerCount:
			var flower = FLOWER.instantiate()
			add_child(flower)
			flowers.append(flower)
			flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
			flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
			flower.setComplete(data.plantFlower)
	elif data.stemComplete and !data.flowerComplete:
		_on_stem_stem_complete()
	configureStats()
	


func _on_currency_gen_timeout():
	SignalBus.addGold.emit(1)

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
		flower.setup(flowerType)
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

func getTooltip(index: int):
	if index == 1:
		return flowerType.trim_suffix("Flower") + " / " + stemType.trim_suffix("Stem")
	elif index == 2:
		return float(stem.getGrowthFrame()) / float(stem.stats.growthFrames)
	elif index == 3:
		if stemComplete and stem.stats.flowerCount != 0:
			return flowers[0].getGrowthPercent()
		else:
			return 0
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
