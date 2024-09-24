extends Control

@onready var seed_shape = $SeedShape
@onready var seed_colour_1 = $SeedColour1
@onready var seed_colour_2 = $SeedColour2

var rootType
var stemType
var flowerType
var plantSpecialType

func setSeed(roots:String,stem:String,flower:String, pSpecialType:String):
	rootType = roots
	stemType = stem
	flowerType = flower
	plantSpecialType = pSpecialType
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
	elif value == "specialType":
		return plantSpecialType


func _on_pressed():
	Global.selectedSeed = self
	Input.set_custom_mouse_cursor(Global.seedCursor)


func _on_mouse_entered():
	SignalBus.mouseTooltip.emit("Select","Sell", "LMB", "RMB", "", false, true)


func _on_mouse_exited():
	SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
