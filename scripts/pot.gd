class_name pot extends Node2D
@onready var pickup_sound = $PickupSound
@onready var place_sound = $PlaceSound
@onready var player = $Player
@onready var plant_marker = $PlantMarker



var processing
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

func _input(event):
	if !(Global.placingItem and dragging):
		if processing:
			if event.is_action_released("LMB"):
				SignalBus.gridToggle.emit(false)
				if Plant != null:
					Plant.shake()
				if overlap == 1:
					place_sound.play()
					SignalBus.mouseTooltip.emit("Pick Up")
				if overlap != 1 and dragging:
					global_position = initialPosition
				dragging = false
				Global.is_dragging = false
				_on_grab_area_mouse_exited()
				player.play("RefreshCollision")

func _process(_delta):
	if Global.state == 1:
		#Mode 1: placing from shop
		if Global.placingItem and dragging:
			SignalBus.gridToggle.emit(true)
			offset2 = (get_global_mouse_position()/10)*10- offset1
			global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
			global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3
			if Input.is_action_just_pressed("LMB"):
				if overlap == 1:
					SignalBus.gridToggle.emit(false)
					dragging = false
					Global.is_dragging = false
					Global.placingItem = false
			if Input.is_action_just_pressed("plantSeed"):
				SignalBus.gridToggle.emit(false)
				Global.is_dragging = false
				Global.placingItem = false
				SignalBus.addGold.emit(Global.itemCost)
				queue_free()
		#Mode 2: sitting on desk	
		if draggable and !Global.placingItem:
			if Input.is_action_just_pressed("LMB"):
				SignalBus.gridToggle.emit(true)
				pickup_sound.play()
				dragging = true
				offset1 = get_global_mouse_position()
				initialPosition = global_position
				Global.is_dragging = true
		#Mode 3: moving existing pot
		if dragging and !Global.placingItem:
			SignalBus.gridToggle.emit(true)
			SignalBus.mouseTooltip.emit("null")
			if Input.is_action_pressed("LMB"):
				offset2 = get_global_mouse_position() - offset1
				global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
				global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3
	if Global.state == 4:
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
			SignalBus.gridToggle.emit(false)
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
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		SignalBus.gridToggle.emit(false)
		set_process(false)


func _on_grab_area_mouse_entered():
	set_process(true)
	processing = true
	if not Global.is_dragging and !removePlant:
		if Global.state == 1:
			SignalBus.mouseTooltip.emit("Pick Up")
		if Global.state == 3 and Plant == null and Global.selectedSeed != null:
			SignalBus.mouseTooltip.emit("Plant Seed")
		draggable = true
		z_index = 1
		if Plant != null:
			if Global.state == 4:
				SignalBus.mouseTooltip.emit("Remove Plant")
			scale = Vector2(1.05,1.05)
			Plant.revealRoots(true)
			SignalBus.setTooltip.emit(Plant.getTooltip(1),Plant.getTooltip(2),Plant.getTooltip(3),Plant.getTooltip(4),Plant.getTooltip(5),Plant.getTooltip(6), Plant.getTooltip(7))
			


func _on_grab_area_mouse_exited():
	if !dragging:
		set_process(false)
		processing = false
	SignalBus.mouseTooltip.emit("null")
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1,1)
		z_index = 0
		if Plant != null:
			Plant.revealRoots(false)
			SignalBus.setTooltip.emit("null",0,0,0,0,0,0)

func _on_grab_area_body_entered(body):
	overlap += 1


func _on_grab_area_body_exited(body):
	overlap -= 1


const PLANT = preload("res://Scenes/plant.tscn")
func newPlant():
	Plant = PLANT.instantiate()
	add_child(Plant)
	Plant.global_position.x = plant_marker.global_position.x
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
		Plant.global_position.x = plant_marker.global_position.x
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
		
