class_name waterCan extends Node2D
@onready var pickup_sound = $PickupSound
@onready var place_sound = $PlaceSound
@onready var player = $Player
@onready var range_indicator = $RangeIndicator
@onready var sprite_2d = $Sprite2D
@onready var water_fill = $WaterFill
@onready var water_bar = $WaterBar




var processing
var draggable = false
var dragging = false
var overlap = 0
var initialPosition
var offset1
var offset2

var filling = false
var resetPosition = false
var outOfWaterFlag = false
var waterCapacity = 100.00
var waterLevel = 100.00
var watering = false
var releaseFlag = false

func _ready():
	SignalBus.saveGame.connect(save)
	SignalBus.fillWater.connect(refill)


func _input(event):
	if !(Global.placingItem and dragging):
		if processing:
			if event.is_action_released("LMB"):
				releaseFlag = true


func _physics_process(delta):
	if filling:
		if outOfWaterFlag:
			SignalBus.outOfWater.emit(false)
			outOfWaterFlag = false
		water_fill.pitch_scale = 1 +((waterLevel/waterCapacity)*0.2)
		waterLevel = waterLevel + delta* 20
		if waterLevel > waterCapacity:
			waterLevel = waterCapacity
			water_fill.stop()
		water_bar.value = waterLevel
	if releaseFlag:
		potRelease()
		releaseFlag = false
	if Global.state == 1:
		#sitting on garden
		if draggable and !Global.placingItem:
			if Input.is_action_just_pressed("LMB"):
				SignalBus.mouseTooltip.emit("Hold: Water","", "RMB", "None", "", false, true)
				SignalBus.gridToggle.emit(true)
				pickup_sound.play()
				dragging = true
				offset1 = get_global_mouse_position()
				initialPosition = global_position
				Global.is_dragging = true
		#Holding Watering Can
		if dragging and !Global.placingItem:
			if Input.is_action_pressed("LMB"):
				if waterLevel <= 0 and !outOfWaterFlag:
					SignalBus.outOfWater.emit(true)
					outOfWaterFlag = true
				offset2 = get_global_mouse_position() - offset1
				global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
				global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3
			if Input.is_action_pressed("RMB") and !filling:
				if resetPosition:
					resetPosition = false
				if sprite_2d.rotation_degrees > -57:
					sprite_2d.rotation_degrees = lerp(sprite_2d.rotation_degrees,-57.00,delta)
					if sprite_2d.rotation_degrees < -40 and !watering:
						watering = true
			if Input.is_action_just_released("RMB"):
				resetPosition = true
			if resetPosition:
				sprite_2d.rotation_degrees = lerp(sprite_2d.rotation_degrees,0.00,delta*2)
				if sprite_2d.rotation_degrees > -40 and watering:
					watering = false
				if is_equal_approx(sprite_2d.rotation_degrees,0.00):
					resetPosition = false
			if watering and waterLevel > 0:
				pourWater(delta)


func pourWater(delta):
	waterLevel-= delta*20
	water_bar.value = waterLevel

func refill(enabled:bool):
	if enabled:
		sprite_2d.rotation_degrees = 0
		watering = false
		if waterLevel != waterCapacity:
			filling = true
			water_fill.play()
	else:
		filling = false
		water_fill.stop()

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		if dragging:
			sprite_2d.rotation_degrees = 0
			outOfWaterFlag = false
			SignalBus.outOfWater.emit(false)
			SignalBus.gridToggle.emit(false)
			global_position = initialPosition
			dragging = false
			Global.is_dragging = false
			draggable = false
			scale = Vector2(1,1)
			z_index = 0
			range_indicator.visible = false
			SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
			if Global.placingItem:
				Global.placingItem = false
				SignalBus.addGold.emit(Global.itemCost)
				queue_free()
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		sprite_2d.rotation_degrees = 0
		outOfWaterFlag = false
		SignalBus.outOfWater.emit(false)
		SignalBus.gridToggle.emit(false)
		set_physics_process(false)


func _on_grab_area_mouse_entered():
	set_physics_process(true)
	processing = true
	if not Global.is_dragging:
		if Global.state == 1:
			SignalBus.mouseTooltip.emit("Pick Up","", "LMB", "None", "", false, true)
		water_bar.visible = true
		water_bar.value = waterLevel
		draggable = true
		z_index = 1
		scale = Vector2(1.05,1.05)
		range_indicator.visible = true


func _on_grab_area_mouse_exited():
	if !dragging:
		water_bar.visible = false
		set_physics_process(false)
		processing = false
		if !Global.placingItem:
				SignalBus.mouseTooltip.emit("","", "None", "None", "", false, false)
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1,1)
		z_index = 0
		range_indicator.visible = false
	


func _on_grab_area_body_entered(_body):
	overlap += 1


func _on_grab_area_body_exited(_body):
	overlap -= 1


func setup():
	initialPosition = get_global_mouse_position()
	offset1 = get_global_mouse_position()
	dragging = true

func save():
	var data = waterCanData.new()
	data.position = global_position
	data.water = waterLevel
	return data

func loadState(data:waterCanData):
	global_position = data.position
	waterLevel = data.water

func potRelease():
	outOfWaterFlag = false
	sprite_2d.rotation_degrees = 0
	SignalBus.outOfWater.emit(false)
	SignalBus.gridToggle.emit(false)
	if overlap == 1:
		place_sound.play()
		SignalBus.mouseTooltip.emit("Pick Up","", "LMB", "None", "", false, true)
	if overlap != 1 and dragging:
		global_position = initialPosition
	dragging = false
	Global.is_dragging = false
	_on_grab_area_mouse_exited()
	player.play("RefreshCollision")


func _on_refill_detect_body_entered(_body):
	refill(true)


func _on_refill_detect_body_exited(_body):
	refill(false)
