extends Node2D
@onready var sprite_2d = $Sprite2d
@onready var growth_timer = $GrowthTimer
const PARTICLES = preload("res://Scenes/particles.tscn")

signal stemComplete
signal growFlowersWhileAway(waterSeconds:float,deltaTime:float)
signal setWaterLevel(waterLevelValue:float)
signal getWaterLevel()

var stats = stemStats.new()
var growthWaitTime
var growthRateModifier = 1

func _ready():
	SignalBus.changeGameSpeed.connect(setGrowthRate)

func setup(stemName: String):
	if stemName == "null":
		get_parent().queue_free()
	else:
		loadStats(Global.stemStatsDict[stemName])
		sprite_2d.play(stemName)
		startGrowing()

func loadStem(data:potData):
	loadStats(Global.stemStatsDict[data.plantStem])
	sprite_2d.play(data.plantStem)
	if data.stemComplete:
		sprite_2d.frame = stats.growthFrames
	else:
		sprite_2d.frame = data.stemFrame
		startGrowing()
		growthWhileAway(data)

func loadStats(path: String):
	stats = load(path)
  
func _on_growth_timer_timeout():
	var water = get_parent().getWaterLevel()
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
		emit_signal("stemComplete")
		var particleEffect = PARTICLES.instantiate()
		add_child(particleEffect)
		particleEffect.global_position = global_position
		particleEffect.setColour(0,1,0)
	elif water > 0.00:
		sprite_2d.frame += 1

func getGrowthFrame():
	return sprite_2d.frame

func startGrowing():
	setGrowthRate()
	growth_timer.start()
	

func setGrowthRate():
	growthWaitTime = 100.00 * (Global.gameSpeed) * (1.00/(float(stats.growthRate)*growthRateModifier))
	#growthWaitTime = Global.gameSpeed * float(100.00/(float(stats.growthRate)* growthRateModifier))
	growth_timer.wait_time = growthWaitTime

func getStat(value: int):
	if value == 1:
		return stats.growthRate
	elif value == 2:
		return stats.productionRate
	elif value == 3:
		return stats.type
	elif value == 4:
		return stats.typeDominance
	elif value == 5:
		return stats.flowerCount
	elif value == 6:
		return stats.sellValue
	elif value == 7: 
		return sprite_2d.frame

func growthWhileAway(data:potData):
	var currentTime = Time.get_unix_time_from_system()
	var deltaTime =  currentTime - Global.lastSaveTime
	var waterSeconds = data.waterSeconds
	while deltaTime > 0 and sprite_2d.frame < stats.growthFrames and waterSeconds > 0:
		if deltaTime >= growthWaitTime:
			sprite_2d.frame += 1
			deltaTime -= growthWaitTime
			waterSeconds -= 2800
		else:
			deltaTime = 0
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
		emit_signal("growFlowersWhileAway", waterSeconds,deltaTime)
	else:
		get_parent().setWaterLevel(waterSeconds)
	
func refreshModifiers(modifiers):
	growthRateModifier = modifiers["StemGrowthRate"]
	setGrowthRate()
