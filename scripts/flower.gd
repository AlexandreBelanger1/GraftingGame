extends Node2D
@onready var sprite_2d = $Sprite2D
@onready var growth_timer = $GrowthTimer
@onready var currency_gen_timer = $CurrencyGenTimer


var statsDict  = {"pansyFlower": "res://Scenes/flowers/pansyFlower.tres",
"cactusFlower": "res://Scenes/flowers/cactusFlower.tres",
"sunflowerFlower":"res://Scenes/flowers/sunflowerFlower.tres",
"chiveFlower": "res://Scenes/flowers/chiveFlower.tres"}
var stats = flowerStats.new()

func _on_growth_timer_timeout():
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
		currency_gen_timer.start()
		get_parent().flowerComplete = true
	else: 
		sprite_2d.frame += 1


func setup(flowerName: String):
	if flowerName == "null":
		loadStats("pansyFlower")
		sprite_2d.play(flowerName)
		growth_timer.start()
	else:
		loadStats(statsDict[flowerName])
		sprite_2d.play(flowerName)
		growth_timer.start()

func setComplete(flowerName: String):
	loadStats(statsDict[flowerName])
	sprite_2d.play(flowerName)
	sprite_2d.frame = stats.growthFrames
	currency_gen_timer.start()

func loadStats(path: String):
	stats = load(path)
  


func _on_currency_gen_timer_timeout():
	SignalBus.addGold.emit(1)
