extends Node

var mobileControls = false


var is_planting = false
var is_dragging = false
var placingItem = false
var gold = 20
var itemCost = 0
var seedPouch

var selectedSeed = null
var plantStem = "null"
var plantFlower = "null"
var plantRoots = "null"

var state = 1
var gameSpeed = 10.00
var lastSaveTime

var stemStatsDict  = {"pansyStem": "res://Scenes/Stems/pansyStem.tres",
"cactusStem": "res://Scenes/Stems/cactusStem.tres",
"sunflowerStem": "res://Scenes/Stems/sunflowerStem.tres",
"bonsaiStem": "res://Scenes/Stems/bonsaiStem.tres",
"chiveStem": "res://Scenes/Stems/chiveStem.tres",
"tomatoStem": "res://Scenes/Stems/tomatoStem.tres",
"poppyStem": "res://Scenes/Stems/poppyStem.tres",
"bleedingheartStem": "res://Scenes/Stems/bleedingheartStem.tres",
"pepperStem": "res://Scenes/Stems/pepperStem.tres",
"tulipStem": "res://Scenes/Stems/tulipStem.tres"}

var flowerStatsDict  = {"pansyFlower": "res://Scenes/flowers/pansyFlower.tres",
"cactusFlower": "res://Scenes/flowers/cactusFlower.tres",
"sunflowerFlower":"res://Scenes/flowers/sunflowerFlower.tres",
"chiveFlower": "res://Scenes/flowers/chiveFlower.tres",
"tomatoFlower": "res://Scenes/flowers/tomatoFlower.tres",
"poppyFlower": "res://Scenes/flowers/poppyFlower.tres",
"bleedingheartFlower": "res://Scenes/flowers/bleedingheartFlower.tres",
"pepperFlower": "res://Scenes/flowers/pepperFlower.tres",
"tulipFlower": "res://Scenes/flowers/tulipFlower.tres"}

var seedImageDict = {"pansyStem":"Seed1",
"sunflowerStem": "Seed2",
"chiveStem": "Seed3",
"cactusStem": "Seed4",
"bonsaiStem": "Seed5",
"tomatoStem": "Seed5",
"poppyStem":  "Seed5",
"bleedingheartStem": "Seed2",
"pepperStem": "Seed1",
"tulipStem":  "Seed4"}
var seedColourDict = {"pansyFlower": Color(0.541, 0.403, 0.997), 
"mediumRoots": Color(0.332, 0.157, 0.066),
"sunflowerFlower": Color(0.801, 0.787, 0.325),
"chiveFlower": Color(0.769, 0.723, 0.969),
"cactusFlower": Color(0.97, 0.815, 0.842),
"smallRoots": Color(0.452, 0.332, 0.121),
"bonsaiRoots": Color(0.191, 0.08, 0.024),
"tomatoFlower": Color(0.855, 0.495, 0.449),
"poppyFlower": Color(0.855, 0.995, 0.449),
"bleedingheartFlower": Color(0.855, 0.995, 0.90),
"pepperFlower": Color(0.855, 0.01, 0.01),
"tulipFlower": Color(1, 1, 1)
}

var WateringCanUpgradePrices = {0:"100",1:"200",2:"300",3:"400",4:"500",5:"100",6:"200",7:"300",8:"400",9:"500",10:"100",11:"200",12:"300",13:"400",14:"500",15:"100"}

var tier1Seeds = {0: "cactus", 1: "sunflower", 2: "chive", 3: "poppy", 4: "tomato", 5: "bleedingheart", 6: "pepper", 7: "tulip"}

var specialTypeDict = {"moon": "res://Scenes/specialTypes/moon.tres", "emerald": "res://Scenes/specialTypes/emerald.tres", "rainbow": "res://Scenes/specialTypes/rainbow.tres"}

var pickupCursor = preload("res://Assets/Sprites/UISprites/CursorTrowel32.png") #preload("res://Assets/Sprites/UISprites/Cursor1.png")
var grabCursor = preload("res://Assets/Sprites/UISprites/CursorTrowel32.png")#preload("res://Assets/Sprites/UISprites/Cursor2.png")
var seedCursor = preload("res://Assets/Sprites/UISprites/CursorTrowel32.png")#preload("res://Assets/Sprites/UISprites/Cursor3.png")
var defaultCursor = preload("res://Assets/Sprites/UISprites/CursorTrowel32.png")#preload("res://Assets/Sprites/UISprites/Cursor4.png")

var decorationPrices = {"GodotPlushie": 40}
