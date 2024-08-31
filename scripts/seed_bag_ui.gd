extends Control
@onready var grid_container = $Background/MarginContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var pickup = $Pickup

const SEED_INVENTORY_SLOT = preload("res://Scenes/seed_inventory_slot.tscn")

func _ready():
	SignalBus.collectSeed.connect(addSeed)

func addSeed(roots:String,stem:String,flower:String):
	pickup.play()
	var slot = SEED_INVENTORY_SLOT.instantiate()
	grid_container.add_child(slot)
	slot.setSeed(roots,stem,flower)
