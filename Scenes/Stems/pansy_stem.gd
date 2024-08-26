extends Node2D
@onready var sprite_2d = $Sprite2d
@onready var growth_timer = $GrowthTimer
const PARTICLES = preload("res://Scenes/particles.tscn")

signal stemComplete

var statsDict  = {"pansyStem": "res://Scenes/Stems/pansyStem.tres",
"cactusStem": "res://Scenes/Stems/cactusStem.tres",
"sunflowerStem": "res://Scenes/Stems/sunflowerStem.tres",
"bonsaiStem": "res://Scenes/Stems/bonsaiStem.tres",
"chiveStem": "res://Scenes/Stems/chiveStem.tres"}
var stats = stemStats.new()


func setup(stemName: String):
	if stemName == "null":
		get_parent().queue_free()
	else:
		loadStats(statsDict[stemName])
		sprite_2d.play(stemName)
		growth_timer.start()

func loadStem(data:potData):
	loadStats(statsDict[data.plantStem])
	sprite_2d.play(data.plantStem)
	if data.stemComplete:
		sprite_2d.frame = stats.growthFrames
	else:
		growth_timer.start()

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
