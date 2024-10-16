class_name decoration extends Node2D
@onready var pickup_sound = $PickupSound
@onready var place_sound = $PlaceSound
@onready var grab_area = $GrabArea





var processing
var draggable = false
var dragging = false
var overlap = 0
var initialPosition
var offset1
var offset2
var decorationType = "GodotPlushie"

var removePlant = false
var sellPlant = false
var releaseFlag = false

func _ready():
	SignalBus.confirmRemove.connect(remove)

func _input(event):
	if !(Global.placingItem and dragging):
		if processing:
			if event.is_action_released("LMB"):
				releaseFlag = true


func _physics_process(_delta):
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
	#Mode 3: moving existing pot
	if dragging and !Global.placingItem:
		if Input.is_action_pressed("LMB"):
			offset2 = get_global_mouse_position() - offset1
			global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
			global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3



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
			SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
			if Global.placingItem:
				Global.placingItem = false
				SignalBus.addGold.emit(Global.itemCost)
				queue_free()
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		SignalBus.gridToggle.emit(false)
		set_physics_process(false)


func _on_grab_area_mouse_entered():
	set_physics_process(true)
	processing = true
	if not Global.is_dragging and !removePlant:
		Input.set_custom_mouse_cursor(Global.pickupCursor)
		SignalBus.mouseTooltip.emit("Pick Up","", "LMB", "None", "", false, true)
		draggable = true
		z_index = 1
		scale = Vector2(1.05,1.05)


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


func _on_grab_area_body_entered(_body):
	overlap += 1


func _on_grab_area_body_exited(_body):
	overlap -= 1


func setup(value:String):
	decorationType = value
	initialPosition = get_global_mouse_position()
	offset1 = get_global_mouse_position()
	dragging = true


func setType(value:String):
	decorationType = value

func save():
	var data = decorationData.new()
	data.position = global_position
	data.decorationType = decorationType
	return data




func remove(value:bool):
	if sellPlant:
		if value == true:
			SignalBus.addGold.emit(250)
			queue_free()
		sellPlant = false
	elif removePlant:
		if value == true:
			queue_free()
		removePlant = false
		
func potRelease():
	SignalBus.gridToggle.emit(false)
	if overlap == 1:
		place_sound.play()
	if overlap != 1 and dragging:
		global_position = initialPosition
	dragging = false
	Global.is_dragging = false
	_on_grab_area_mouse_exited()
	grab_area.refesh()
