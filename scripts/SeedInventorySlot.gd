extends Control

@onready var seed_shape = $SeedShape
@onready var seed_colour_1 = $SeedColour1
@onready var seed_colour_2 = $SeedColour2
@onready var seed_tooltip = $SeedTooltip


var rootType
var stemType
var flowerType
var plantSpecialType

var hovered = false

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
	seed_tooltip.setTooltip(roots,stem,flower,pSpecialType)



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
	seed_tooltip.visible = true
	hovered = true


func _on_mouse_exited():
	SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
	seed_tooltip.visible = false
	hovered = false


func saveSeed():
	var data = seedData.new()
	data.flowerType = flowerType
	data.plantSpecialType = plantSpecialType
	data.rootType = rootType
	data.stemType = stemType
	return data

func _input(event):
	if Input.is_action_just_pressed("RMB") and hovered:
		SignalBus.addGold.emit(1)
		queue_free()
