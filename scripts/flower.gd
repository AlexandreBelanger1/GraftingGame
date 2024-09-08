extends Node2D
@onready var sprite_2d = $Sprite2D
@onready var growth_timer = $GrowthTimer
@onready var seed_gen_timer = $SeedGenTimer
@onready var seed_particles = $SeedParticles


const SEED = preload("res://Scenes/seed.tscn")

var stats = flowerStats.new()
var RNG = RandomNumberGenerator.new()
var seed = null
var proximityPlants = []

func _ready():
	SignalBus.changeGameSpeed.connect(setGrowthRate)

func _on_growth_timer_timeout():
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
		seed_gen_timer.start()
		get_parent().flowerComplete = true
	else: 
		sprite_2d.frame += 1


func setup(flowerName: String):
	if flowerName == "null":
		loadStats("pansyFlower")
		sprite_2d.play(flowerName)
		setGrowthRate()
		growth_timer.start()
	else:
		loadStats(Global.flowerStatsDict[flowerName])
		sprite_2d.play(flowerName)
		setGrowthRate()
		growth_timer.start()

func setComplete(flowerName: String):
	loadStats(Global.flowerStatsDict[flowerName])
	sprite_2d.play(flowerName)
	sprite_2d.frame = stats.growthFrames
	setGrowthRate()
	seed_gen_timer.start()

func loadStats(path: String):
	stats = load(path)
  


func _on_seed_gen_timer_timeout():
	var rand = RNG.randf_range(0,10)
	if rand > 9.8 and seed == null:
		generateProximitySeed()
		seed_particles.emitting = true

func generateRandomSeed():
	var randRoot = RNG.randf_range(0,3)
	var randStem = RNG.randf_range(0,8)
	var randFlower = RNG.randf_range(0,7)
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
	elif randStem > 4 and randStem <= 5:
		seedStem = "tomatoStem"
	elif randStem > 5 and randStem <= 6:
		seedStem = "poppyStem"
	elif randStem > 6 and randStem <= 7:
		seedStem = "bleedingheartStem"
	else:
		seedStem = "bonsaiStem"
	if randFlower <=1:
		seedFlower = "pansyFlower"
	elif randFlower >1 and randFlower <= 2:
		seedFlower = "cactusFlower"
	elif randFlower >2 and randFlower <= 3:
		seedFlower = "sunflowerFlower"
	elif randFlower >3 and randFlower <= 4:
		seedFlower = "tomatoFlower"
	elif randFlower >4 and randFlower <= 5:
		seedFlower = "poppyFlower"
	elif randFlower >5 and randFlower <= 6:
		seedFlower = "bleedingheartFlower"
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

func setGrowthRate():
	growth_timer.wait_time = Global.gameSpeed * (1/stats.growthRate)
	seed_gen_timer.wait_time = Global.gameSpeed * (1/stats.productionRate)

func getGrowthPercent():
	return float(float(sprite_2d.frame) / float(stats.growthFrames))

func getStat(value: int):
	if value == 1:
		return stats.growthRate
	elif value == 2:
		return stats.productionRate
	elif value == 3:
		return stats.type
	elif value == 4:
		return stats.typeDominance


func _on_plant_detect_body_entered(body):
	proximityPlants.append(body)

func _on_plant_detect_body_exited(body):
	var index = 0
	for i in proximityPlants:
		if body == i:
			proximityPlants.remove_at(index)
		index += 1

func generateProximitySeed():
	if proximityPlants.size() >= 2:
		var seedRoot
		var seedStem
		var seedFlower
		seed = SEED.instantiate()
		add_child(seed)
		
		#Pick Root Type
		var rand =  RNG.randf_range(0,1)
		if rand > 0.5:
			seedRoot = get_parent().getComponent(1)
		else:
			rand = int(RNG.randf_range(0,proximityPlants.size()))
			seedRoot = proximityPlants[rand].getComponent(1)
			
		#Pick Stem Type
		rand =  RNG.randf_range(0,1)
		if rand > 0.5:
			seedStem = get_parent().getComponent(2)
		else:
			rand = int(RNG.randf_range(0,proximityPlants.size()))
			seedStem = proximityPlants[rand].getComponent(2)
			
		#Pick Flower Type
		rand =  RNG.randf_range(0,1)
		if rand > 0.5:
			seedFlower = get_parent().getComponent(3)
		else:
			rand = int(RNG.randf_range(0,proximityPlants.size()))
			seedFlower = proximityPlants[rand].getComponent(3)
		seed.generateSeed(seedRoot,seedStem,seedFlower)
		seed.visible = false

