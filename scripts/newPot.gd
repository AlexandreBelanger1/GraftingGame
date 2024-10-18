class_name pot extends CharacterBody2D
@onready var pickup_sound = $PickupSound
@onready var place_sound = $PlaceSound
@onready var plant_marker = $PlantMarker
@onready var grab_area = $GrabArea
@onready var options_open = $OptionsOpen
@onready var options_close = $OptionsClose


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
var removePlant = false
var sellPlantFlag = false
var releaseFlag = false




func _ready():
	SignalBus.saveGame.connect(save)
	#SignalBus.setState.connect(changeState)
	SignalBus.confirmRemove.connect(remove)


func _input(event):
	if !(Global.placingItem and dragging):
		if processing:
			if event.is_action_released("LMB"):
				releaseFlag = true

func _physics_process(_delta):
	if Plant != null:
		SignalBus.setTooltip.emit(Plant.getTooltip(1),Plant.getTooltip(2),Plant.getTooltip(3),Plant.getTooltip(4),Plant.getTooltip(5),Plant.getTooltip(6), Plant.getTooltip(7))
	if releaseFlag:
		potRelease()
		releaseFlag = false
	#Mode 1: placing from shop
	if Global.placingItem and dragging:
		offset2 = (get_global_mouse_position()/10)*10- offset1
		global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
		global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3
		if Input.is_action_just_released("LMB"):
			if overlap > 1:
				SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "Not enough room!", true, true)
			if overlap == 1:
				place_sound.play()
				SignalBus.gridToggle.emit(false)
				dragging = false
				Global.is_dragging = false
				Global.placingItem = false
				Input.set_custom_mouse_cursor(Global.defaultCursor)
				SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
		if Input.is_action_just_pressed("plantSeed"):
			SignalBus.mouseTooltip.emit("","", "None", "None", "Refunded!", true, true)
			SignalBus.gridToggle.emit(false)
			Global.is_dragging = false
			Global.placingItem = false
			SignalBus.addGold.emit(Global.itemCost)
			queue_free()
	#Mode 2: sitting on desk	
	if draggable and !Global.placingItem:
		if Input.is_action_just_pressed("LMB"):
			Input.set_custom_mouse_cursor(Global.grabCursor)
			SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
			SignalBus.gridToggle.emit(true)
			pickup_sound.play()
			dragging = true
			offset1 = get_global_mouse_position()
			initialPosition = global_position
			Global.is_dragging = true
		if Input.is_action_just_pressed("RMB"):
			if Plant != null:
				if Plant.getPlantOptions():
					SignalBus.plantOptions.emit(false)
					options_close.play()
				else:
					SignalBus.plantOptions.emit(false)
					Plant.enablePlantOptions(true)
					options_open.play()
			else:
				if Global.selectedSeed != null:
					newPlant()
	#Mode 3: moving existing pot
	if dragging and !Global.placingItem:
		if Input.is_action_pressed("LMB"):
			offset2 = get_global_mouse_position() - offset1
			global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
			global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3



func sellPlant():
	sellPlantFlag = true
	SignalBus.confirmUI.emit()

func harvestPlant():
	if Plant.getTooltip(8):
		Plant.sellFlowers()

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
				Plant.waterBarEnable(false)
				Plant.revealRoots(false)
				SignalBus.setTooltip.emit("null",0,0,0,0,0,0)
			SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
			if Global.placingItem:
				Global.placingItem = false
				SignalBus.addGold.emit(Global.itemCost)
				queue_free()
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		SignalBus.gridToggle.emit(false)
		set_physics_process(false)


func _on_grab_area_mouse_entered():
	if not Global.is_dragging:
		set_physics_process(true)
		processing = true
		draggable = true
		z_index = 1
		if Plant == null:
			Input.set_custom_mouse_cursor(Global.pickupCursor)
			SignalBus.mouseTooltip.emit("Pick Up","", "LMB", "None","", false, true)
			if Global.selectedSeed != null:
				Input.set_custom_mouse_cursor(Global.seedCursor)
				SignalBus.mouseTooltip.emit("Pick Up","Plant Seed", "LMB", "RMB","", false, true)
		else:
			Input.set_custom_mouse_cursor(Global.pickupCursor)
			SignalBus.mouseTooltip.emit("Pick Up","Options", "LMB", "RMB", "", false, true)
			Plant.waterBarEnable(true)
			scale = Vector2(1.05,1.05)
			Plant.revealRoots(true)
			SignalBus.setTooltip.emit(Plant.getTooltip(1),Plant.getTooltip(2),Plant.getTooltip(3),Plant.getTooltip(4),Plant.getTooltip(5),Plant.getTooltip(6), Plant.getTooltip(7))
			


func _on_grab_area_mouse_exited():
	if !dragging:
		set_physics_process(false)
		processing = false
		if !Global.placingItem:
			SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
	if not Global.is_dragging:
		Input.set_custom_mouse_cursor(Global.defaultCursor)
		draggable = false
		scale = Vector2(1,1)
		z_index = 0
		if Plant != null:
			Plant.waterBarEnable(false)
			Plant.revealRoots(false)
			SignalBus.setTooltip.emit("null",0,0,0,0,0,0)

func _on_grab_area_body_entered(_body):
	overlap += 1


func _on_grab_area_body_exited(_body):
	overlap -= 1


const PLANT = preload("res://Scenes/plant.tscn")
func newPlant():
	Plant = PLANT.instantiate()
	add_child(Plant)
	Plant.global_position.x = plant_marker.global_position.x
	Plant.global_position.y = global_position.y + stats.plantOffset
	Plant.setup()
	set_collision_layer_value(9,true)
	grab_area.refesh()

func potSetup(potName: String):
	potType = potName
	initialPosition = get_global_mouse_position()
	offset1 = get_global_mouse_position()
	dragging = true
	loadStats(statsDict[potName])

func setPotType(potName:String):
	potType = potName

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
		data.plantSpecialType = Plant.save(6)
		data.stemFrame = Plant.save(7)
		data.flowerFrame = Plant.save(8)
		data.waterSeconds = Plant.save(9)
	return data

func loadState(data:potData):
	set_physics_process(false)
	global_position = data.position
	potType = data.potType
	loadStats(statsDict[potType])
	if data.containsPlant:
		Plant = PLANT.instantiate()
		add_child(Plant)
		Plant.global_position.x = plant_marker.global_position.x
		Plant.global_position.y = global_position.y + stats.plantOffset
		set_collision_layer_value(9,true)
		Plant.loadPlant(data)


#func changeState(value:int):
#	state = value

func remove(value:bool):
	if sellPlantFlag:
		if value == true:
			if Plant.getTooltip(8):
				SignalBus.addGold.emit(Plant.getTooltip(7))
				Plant.queue_free()
				set_collision_layer_value(9,false)
				SignalBus.setTooltip.emit("null",0,0,0,0,0,0)
		sellPlantFlag = false
	elif removePlant:
		if value == true:
			Plant.queue_free()
			set_collision_layer_value(9,false)
			SignalBus.setTooltip.emit("null",0,0,0,0,0,0)
		removePlant = false
		
func potRelease():
	SignalBus.gridToggle.emit(false)
	if Plant != null:
		Plant.shake()
	if overlap == 1:
		place_sound.play()
	if overlap != 1 and dragging:
		global_position = initialPosition
	dragging = false
	Global.is_dragging = false
	_on_grab_area_mouse_exited()
	grab_area.refesh()

func addWater():
	if Plant!=null:
		Plant.addWater()

func addModifier(type:String,magnitude:float):
	if Plant!=null:
		Plant.addModifier(type,magnitude)

func removeModifier(type:String,magnitude:float):
	if Plant!=null:
		Plant.removeModifier(type,magnitude)
