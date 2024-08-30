class_name pot extends Node2D
@onready var pickup_sound = $PickupSound
@onready var place_sound = $PlaceSound



var draggable = false
var dragging = false
var overlap = 0
var initialPosition
var offset1
var offset2
var Plant
var statsDict  = {"smallPot": "res://Scenes/Pots/SmallPot.tres", "mediumPot": "res://Scenes/Pots/MediumPot.tres", "bonsaiPot": "res://Scenes/Pots/bonsaiPot.tres"}
var stats = potStats.new()
var potType
#var state = 1
var removePlant = false

func _ready():
	SignalBus.saveGame.connect(save)
	#SignalBus.setState.connect(changeState)
	SignalBus.confirmRemove.connect(remove)

func _process(_delta):
	
	if Global.state == 1:
		#Mode 1: placing from shop
		if Global.placingItem and dragging:
			offset2 = get_global_mouse_position() - offset1
			global_position = initialPosition + offset2
			if Input.is_action_just_pressed("LMB"):
				if overlap == 1:
					place_sound.play()
					dragging = false
					Global.is_dragging = false
					Global.placingItem = false
			if Input.is_action_just_pressed("plantSeed"):
				Global.is_dragging = false
				Global.placingItem = false
				SignalBus.addGold.emit(Global.itemCost)
				queue_free()
		#Mode 2: sitting on desk	
		if draggable:
			if Input.is_action_just_pressed("LMB"):
				pickup_sound.play()
				dragging = true
				offset1 = get_global_mouse_position()
				initialPosition = global_position
				Global.is_dragging = true
		#Mode 3: moving existing pot
		if dragging and !Global.placingItem:
			SignalBus.mouseTooltip.emit("null")
			if Input.is_action_pressed("LMB"):
				offset2 = get_global_mouse_position() - offset1
				global_position = initialPosition + offset2
			
			if Input.is_action_just_released("LMB"):
				if Plant != null:
					Plant.shake()
				if overlap == 1:
					place_sound.play()
					SignalBus.mouseTooltip.emit("Pick Up")
				if overlap != 1:
					global_position = initialPosition
				dragging = false
				Global.is_dragging = false
	if Global.state == 2:
		if Input.is_action_just_pressed("LMB") and draggable:
				if Plant != null:
					removePlant = true
					SignalBus.confirmUI.emit()
	if Global.state == 3:
		if draggable:
			if Input.is_action_just_pressed("LMB"):
				if Plant == null:
					newPlant()



func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		if dragging:
			global_position = initialPosition
			dragging = false
			Global.is_dragging = false
			draggable = false
			scale = Vector2(1,1)
			z_index = 0
			if Plant != null:
				Plant.revealRoots(false)
				SignalBus.setTooltip.emit("null",0)
				SignalBus.mouseTooltip.emit("null")


func _on_grab_area_mouse_entered():
	set_process(true)
	if not Global.is_dragging and !removePlant:
		if Global.state == 1:
			SignalBus.mouseTooltip.emit("Pick Up")
		if Global.state == 3 and Plant == null and Global.selectedSeed != null:
			SignalBus.mouseTooltip.emit("Plant Seed")
		draggable = true
		z_index = 1
		if Plant != null:
			if Global.state == 2:
				SignalBus.mouseTooltip.emit("Remove Plant")
			scale = Vector2(1.05,1.05)
			Plant.revealRoots(true)
			SignalBus.setTooltip.emit(Plant.getTooltip(1),Plant.getTooltip(2))
			


func _on_grab_area_mouse_exited():
	if !dragging:
		set_process(false)
	SignalBus.mouseTooltip.emit("null")
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1,1)
		z_index = 0
		if Plant != null:
			Plant.revealRoots(false)
			SignalBus.setTooltip.emit("null",0)

func _on_grab_area_body_entered(body):
	overlap += 1


func _on_grab_area_body_exited(body):
	overlap -= 1


const PLANT = preload("res://Scenes/plant.tscn")
func newPlant():
	Plant = PLANT.instantiate()
	add_child(Plant)
	Plant.global_position.x = global_position.x
	Plant.global_position.y = global_position.y + stats.plantOffset
	Plant.setup()

func potSetup(potName: String):
	potType = potName
	initialPosition = get_global_mouse_position()
	offset1 = get_global_mouse_position()
	dragging = true
	loadStats(statsDict[potName])

func loadStats(path: String):
	stats = load(path)

func save():
	var data = potData.new()
	data.position = global_position
	data.potType = potType
	if Plant != null:
		data.containsPlant = true
		data.stemComplete = Plant.save(1)
		data.flowerComplete = Plant.save(2)
		data.plantRoots = Plant.save(3)
		data.plantStem = Plant.save(4)
		data.plantFlower = Plant.save(5)
	return data

func loadState(data:potData):
	global_position = data.position
	potType = data.potType
	loadStats(statsDict[potType])
	if data.containsPlant:
		Plant = PLANT.instantiate()
		add_child(Plant)
		Plant.global_position.x = global_position.x
		Plant.global_position.y = global_position.y + stats.plantOffset
		Plant.loadPlant(data)

#func changeState(value:int):
#	state = value

func remove(value:bool):
	if removePlant:
		if value == true:
			Plant.queue_free()
			SignalBus.setTooltip.emit("null",0)
		removePlant = false
		
