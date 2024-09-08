extends Control

@onready var seed_shape = $SeedShape
@onready var seed_colour_1 = $SeedColour1
@onready var seed_colour_2 = $SeedColour2

var rootType
var stemType
var flowerType

func setSeed(roots:String,stem:String,flower:String):
	rootType = roots
	stemType = stem
	flowerType = flower
	
	seed_shape.texture  = load("res://Assets/Sprites/SeedSprites/" + Global.seedImageDict[stemType] + "Shape.png")
	seed_colour_1.texture  = load("res://Assets/Sprites/SeedSprites/" + Global.seedImageDict[stemType] + "Colour1.png")
	seed_colour_2.texture  = load("res://Assets/Sprites/SeedSprites/" + Global.seedImageDict[stemType] + "Colour2.png")
	seed_colour_1.modulate = Global.seedColourDict[rootType]
	seed_colour_2.modulate = Global.seedColourDict[flowerType]



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
