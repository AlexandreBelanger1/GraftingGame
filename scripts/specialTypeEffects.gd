extends Node2D
@onready var effects_timer = $EffectsTimer

var colourList = []
var index = 0
var numColours
func start(effectName:String):
	var specialStats = load(Global.specialTypeDict[effectName])
	numColours = specialStats.colourPalette.size()
	for colour in specialStats.colourPalette:
		colourList.append(colour)
		effects_timer.wait_time = specialStats.changeTime
		effects_timer.start()


func _on_effects_timer_timeout():
	get_parent().modulate = colourList[index]
	index = (index + 1) % numColours
