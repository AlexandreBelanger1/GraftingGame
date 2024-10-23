extends Control

@onready var incomplete = $Incomplete
@onready var complete = $Complete
@onready var icon = $Icon
@onready var title = $Title
@onready var progress_bar = $Incomplete/ProgressBar
@onready var unknown = $Unknown


var titleDict = {"pansyStem": "Pansy Enjoyer","poppyStem": "Can't Stoppy","cactusStem": "A prickly quest","bleedingheartStem": "My heart is bleeding","chiveStem": "Good taste",
"tulipStem": "Can I eat this?","sunflowerStem": "Taller than me!","tomatoStem": "Don't eat","pepperStem": "Flavor factory",
"pansyFlower": "Pansy Smeller", "poppyFlower": "Rememberance", "cactusFlower": "Rare beauty", "bleedingheartFlower": "It's heart shaped!","chiveFlower": "Not good taste", "tulipFlower": "Deer snack", "sunflowerFlower": "Slava", 
"tomatoFlower": "Eat", "pepperFlower": "Holy Jalapenos"}


func setup(value:String):
	icon.play(value)
	title.text = titleDict[value]
	
func setActive():
	unknown.visible = false

func setProgress(value:float):
	progress_bar.value = value
	if unknown.visible:
		unknown.visible = false

func setComplete():
	unknown.visible = false
	complete.visible = true
	incomplete.visible = false

func setUnknown():
	unknown.visible = true
	complete.visible = false
	incomplete.visible = true
