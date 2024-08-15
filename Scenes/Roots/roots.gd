extends Node2D
@onready var sprite_2d = $Sprite2D
@onready var growth_timer = $GrowthTimer

var statsDict  = {"pansyRoots": "res://Scenes/Roots/pansyRoots.tres", "cactusRoots":"res://Scenes/Roots/cactusRoots.tres", "sunflowerRoots": "res://Scenes/Roots/cactusRoots.tres", "bonsaiRoots":"res://Scenes/Roots/bonsaiRoots.tres"}
var stats = rootStats.new()


func setup(rootName: String):
	if rootName == "null":
		get_parent().queue_free()
	else:
		loadStats(statsDict[rootName])
		sprite_2d.play(rootName)
		growth_timer.start()

func loadStats(path: String):
	stats = load(path)
  
func revealRoots(value: bool):
	sprite_2d.visible = value


func _on_growth_timer_timeout():
	if sprite_2d.frame == stats.growthFrames:
		growth_timer.stop()
	else:
		sprite_2d.frame += 1
