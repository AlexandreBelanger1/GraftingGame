extends Node2D
@onready var sprite_2d = $Sprite2d
@onready var growth_timer = $GrowthTimer
const PARTICLES = preload("res://Scenes/particles.tscn")

signal stemComplete

var statsDict  = {"pansyStem": "res://Scenes/Stems/pansyStem.tres",
"cactusStem": "res://Scenes/Stems/cactusStem.tres",
"sunflowerStem": "res://Scenes/Stems/sunflowerStem.tres",
"bonsaiStem": "res://Scenes/Stems/bonsaiStem.tres",
"chiveStem": "res://Scenes/Stems/chiveStem.tres",
"tomatoStem": "res://Scenes/Stems/tomatoStem.tres",
"poppyStem": "res://Scenes/Stems/poppyStem.tres",
"bleedingheartStem": "res://Scenes/Stems/bleedingheartStem.tres"}
var stats = stemStats.new()

func _ready():
	SignalBus.changeGameSpeed.connect(setGrowthRate)

func setup(stemName: String):
	if stemName == "null":
		get_parent().queue_free()
	else:
		loadStats(statsDict[stemName])
		sprite_2d.play(stemName)
		startGrowing()

func loadStem(data:potData):
	loadStats(statsDict[data.plantStem])
	sprite_2d.play(data.plantStem)
	if data.stemComplete:
		sprite_2d.frame = stats.growthFrames
	else:
		startGrowing()

func loadStats(path: String):
	stats = load(path)
  
func _on_growth_timer_timeout():
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
		emit_signal("stemComplete")
		var particleEffect = PARTICLES.instantiate()
		add_child(particleEffect)
		particleEffect.global_position = global_position
		particleEffect.setColour(0,1,0)
	else:
		sprite_2d.frame += 1
func getGrowthFrame():
	return sprite_2d.frame

func startGrowing():
	setGrowthRate()
	growth_timer.start()

func setGrowthRate():
	growth_timer.wait_time = Global.gameSpeed * float(1/float(stats.growthRate))

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
