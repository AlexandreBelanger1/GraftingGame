class_name plant extends Node2D
@onready var roots = $Roots
@onready var stem = $stem
@onready var currency_gen = $CurrencyGen
const FLOWER = preload("res://Scenes/flowers/flower.tscn")
var flowers = []
var stats
var flowerType
var rootType
var stemType
var stemComplete = false
var flowerComplete = false
func setup():
	roots.setup(Global.plantRoots)
	checkRootSize()
	stem.setup(Global.plantStem)
	flowerType = Global.plantFlower
	rootType = Global.plantRoots
	stemType = Global.plantStem

func loadPlant(data:potData):
	flowerComplete  = data.flowerComplete
	stemComplete = data.stemComplete
	flowerType = data.plantFlower
	rootType = data.plantRoots
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
	


func _on_currency_gen_timeout():
	SignalBus.addGold.emit(1)

func _on_pansy_flower_flower_complete():
	currency_gen.start()

func revealRoots(value: bool):
	roots.revealRoots(value)

func checkRootSize():
	var potSize = get_parent().stats.size
	var potType = get_parent().stats.specialType
	var rootType = roots.stats.specialType
	if potSize < roots.stats.size:
		queue_free()
	# rootType 0 is for non-special pot requirements
	if rootType != 0:
		if rootType != potType:
			queue_free()

func _on_stem_stem_complete():
	stemComplete = true
	for i in stem.stats.flowerCount:
		var flower = FLOWER.instantiate()
		add_child(flower)
		flowers.append(flower)
		flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
		flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
		flower.setup(flowerType)

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
		return flowerType + stemType + rootType
	if index == 2:
		return float(stem.getGrowthFrame()) / float(stem.stats.growthFrames)
