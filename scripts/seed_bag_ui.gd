extends Control
@onready var grid_container = $Background/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var pickup = $Pickup

const SEED_INVENTORY_SLOT = preload("res://Scenes/seed_inventory_slot.tscn")
var potSizes = {0: "smallRoots", 1: "mediumRoots", 2: "bonsaiRoots"}
var RNG = RandomNumberGenerator.new()
func _ready():
	SignalBus.collectSeed.connect(addSeed)
	SignalBus.generateMysterySeed.connect(generateMysterySeed)

func addSeed(roots:String,stem:String,flower:String):
	pickup.play()
	var slot = SEED_INVENTORY_SLOT.instantiate()
	grid_container.add_child(slot)
	slot.setSeed(roots,stem,flower)

func generateMysterySeed(tier: int):
	var rand 
	var rootSize
	rand = int(RNG.randf_range(0,2.99))
	rootSize = potSizes[rand]
	if tier == 1:
		rand = int(RNG.randf_range(0, Global.tier1Seeds.size()-0.01))
		addSeed(rootSize, Global.tier1Seeds[rand]+"Stem",Global.tier1Seeds[rand]+"Flower")
