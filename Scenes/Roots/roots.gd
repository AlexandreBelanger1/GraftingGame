extends Node2D
@onready var sprite_2d = $Sprite2D
@onready var growth_timer = $GrowthTimer

var statsDict  = {"mediumRoots": "res://Scenes/Roots/pansyRoots.tres",
"smallRoots":"res://Scenes/Roots/cactusRoots.tres",
"bonsaiRoots":"res://Scenes/Roots/bonsaiRoots.tres"}
var stats = rootStats.new()


func setup(rootName: String):
	if rootName == "null":
		get_parent().queue_free()
	else:
		loadStats(statsDict[rootName])
		sprite_2d.play(rootName)
		growth_timer.start()

func loadRoots(data: potData):
	var roots = data.plantRoots
	if roots == "pansyRoots":
		roots = "mediumRoots"
	if roots == "sunflowerRoots":
		roots = "mediumRoots"
	if roots == "cactusRoots":
		roots = "smallRoots"
	loadStats(statsDict[roots])
	sprite_2d.play(roots)
	sprite_2d.frame = stats.growthFrames

func loadStats(path: String):
	stats = load(path)
  
func revealRoots(value: bool):
	sprite_2d.visible = value


func _on_growth_timer_timeout():
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
	else:
		sprite_2d.frame += 1
