extends Node2D
@onready var sprite_2d = $Sprite2D
@onready var growth_timer = $GrowthTimer
@onready var currency_gen_timer = $CurrencyGenTimer
@onready var seed_particles = $SeedParticles


const SEED = preload("res://Scenes/seed.tscn")
var statsDict  = {"pansyFlower": "res://Scenes/flowers/pansyFlower.tres",
"cactusFlower": "res://Scenes/flowers/cactusFlower.tres",
"sunflowerFlower":"res://Scenes/flowers/sunflowerFlower.tres",
"chiveFlower": "res://Scenes/flowers/chiveFlower.tres"}
var stats = flowerStats.new()
var RNG = RandomNumberGenerator.new()
var seed = null

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
	var rand = RNG.randf_range(0,10)
	if rand > 9.8 and seed == null:
		generateRandomSeed()
		seed_particles.emitting = true
	SignalBus.addGold.emit(1)

func generateRandomSeed():
	var randRoot = RNG.randf_range(0,3)
	var randStem = RNG.randf_range(0,5)
	var randFlower = RNG.randf_range(0,4)
	var seedRoot
	var seedStem
	var seedFlower
	seed = SEED.instantiate()
	add_child(seed)
	if randRoot <=1:
		seedRoot = "smallRoots"
	elif randRoot >=2:
		seedRoot = "bonsaiRoots"
	else:
		seedRoot = "mediumRoots"
	if randStem <= 1:
		seedStem = "pansyStem"
	elif randStem > 1 and randStem <= 2:
		seedStem = "cactusStem"
	elif randStem > 2 and randStem <= 3:
		seedStem = "sunflowerStem"
	elif randStem > 3 and randStem <= 4:
		seedStem = "chiveStem"
	else:
		seedStem = "bonsaiStem"
	if randFlower <=1:
		seedFlower = "pansyFlower"
	elif randFlower >1 and randFlower <= 2:
		seedFlower = "cactusFlower"
	elif randFlower >2 and randFlower <= 3:
		seedFlower = "sunflowerFlower"
	else:
		seedFlower = "chiveFlower"
	seed.generateSeed(seedRoot,seedStem,seedFlower)
	seed.visible = false

func shakeFlower():
	if seed != null:
		seed_particles.emitting = false
		seed.visible = true
		remove_child(seed)
		get_parent().get_parent().get_parent().add_child(seed)
		seed.global_position.y = get_parent().get_parent().global_position.y + 10
		seed.global_position.x = global_position.x
		seed = null
