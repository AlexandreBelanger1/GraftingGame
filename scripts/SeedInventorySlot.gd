extends Control

@onready var seed_shape = $SeedShape
@onready var seed_colour_1 = $SeedColour1
@onready var seed_colour_2 = $SeedColour2

var seedImageDict = {"pansyStem":"Seed1", "sunflowerStem": "Seed2", "chiveStem": "Seed3", "cactusStem": "Seed4", "bonsaiStem": "Seed5", "tomatoStem": "Seed5", "poppyStem":  "Seed5", "bleedingheartStem": "Seed2"}
var colourDict = {"pansyFlower": Color(0.541, 0.403, 0.997), 
"mediumRoots": Color(0.332, 0.157, 0.066),
"sunflowerFlower": Color(0.801, 0.787, 0.325),
"chiveFlower": Color(0.769, 0.723, 0.969),
"cactusFlower": Color(0.97, 0.815, 0.842),
"smallRoots": Color(0.452, 0.332, 0.121),
"bonsaiRoots": Color(0.191, 0.08, 0.024),
"tomatoFlower": Color(0.855, 0.495, 0.449),
"poppyFlower": Color(0.855, 0.995, 0.449),
"bleedingheartFlower": Color(0.855, 0.995, 0.90) ,
}

var rootType
var stemType
var flowerType

func setSeed(roots:String,stem:String,flower:String):
	rootType = roots
	stemType = stem
	flowerType = flower
	
	seed_shape.texture  = load("res://Assets/Sprites/SeedSprites/" + seedImageDict[stemType] + "Shape.png")
	seed_colour_1.texture  = load("res://Assets/Sprites/SeedSprites/" + seedImageDict[stemType] + "Colour1.png")
	seed_colour_2.texture  = load("res://Assets/Sprites/SeedSprites/" + seedImageDict[stemType] + "Colour2.png")
	seed_colour_1.modulate = colourDict[rootType]
	seed_colour_2.modulate = colourDict[flowerType]



func getSeed(value:String):
	if value == "roots":
		return rootType
	elif value == "stem":
		return stemType
	elif value == "flower":
		return flowerType


func _on_pressed():
	Global.selectedSeed = self
	print_debug(Global.selectedSeed)
