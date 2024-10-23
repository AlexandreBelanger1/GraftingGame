class_name gameStats extends Resource

@export var goldEarned:int
@export var XPEarned:int
@export var seedsPlanted:int
@export var flowersHarvested:int
@export var seedsHarvested:int
@export var seedsSold:int
@export var plantsSold:int
@export var waterUsed:float
@export var inGameTime:int
@export var worldTimeStart:String
@export var flowerDict = { "pansyFlower": 0, "poppyFlower": 0, "cactusFlower": 0, "bleedingheartFlower": 0,"chiveFlower": 0, "tulipFlower": 0, "sunflowerFlower": 0, 
"tomatoFlower": 0, "pepperFlower": 0}
@export var stemDict = {"pansyStem": 0,"poppyStem": 0,"cactusStem": 0,"bleedingheartStem": 0,"chiveStem": 0,"tulipStem": 0,"sunflowerStem": 0,"tomatoStem": 0,"pepperStem": 0}
@export var achieved = []
@export var active = []
@export var inactive = ["pansyStem","poppyStem","cactusStem","bleedingheartStem","chiveStem","tulipStem","sunflowerStem","tomatoStem","pepperStem","pansyFlower", "poppyFlower",
 "cactusFlower", "bleedingheartFlower","chiveFlower", "tulipFlower", "sunflowerFlower", "tomatoFlower", "pepperFlower"]
