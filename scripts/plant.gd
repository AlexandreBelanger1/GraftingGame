class_name plant extends Node2D
@onready var roots = $PansyRoots
@onready var stem = $pansy_stem
@onready var currency_gen = $CurrencyGen
const FLOWER = preload("res://Scenes/flowers/flower.tscn")
var flowers = []
var stats
var flowerType
func setup():
	roots.setup(Global.plantRoots)
	checkRootSize()
	stem.setup(Global.plantStem)
	flowerType = Global.plantFlower
	



func _on_currency_gen_timeout():
	SignalBus.addGold.emit(1)


func _on_pansy_stem_stem_complete():
	for i in stem.stats.flowerCount:
		var flower = FLOWER.instantiate()
		add_child(flower)
		flowers.append(flower)
		flower.global_position.x = global_position.x + stem.stats.flowerPositions[i].x
		flower.global_position.y = global_position.y + stem.stats.flowerPositions[i].y
		flower.setup(flowerType)


func _on_pansy_flower_flower_complete():
	currency_gen.start()

func revealRoots(value: bool):
	roots.revealRoots(value)

func checkRootSize():
	var potSize = get_parent().stats.size
	if potSize < roots.stats.size:
		queue_free()
