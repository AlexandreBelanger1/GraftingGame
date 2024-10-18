class_name waterCan extends Node2D
@onready var pickup_sound = $PickupSound
@onready var place_sound = $PlaceSound
@onready var range_indicator = $RangeIndicator
@onready var sprite_2d = $Sprite2D
@onready var water_fill = $WaterFill
@onready var water_bar = $WaterBar
@onready var water_particles = $Sprite2D/WaterParticles
@onready var watering_sound = $WateringSound
@onready var effect_range = $EffectRange
@onready var grab_area = $GrabArea
@onready var watering_can_upgrade_ui = $WateringCanUpgradeUI
@onready var effect_collider = $EffectRange/EffectCollider

#RGB Profile
var red = 1
var green = 1
var blue = 1

#Upgrade values per tier
var areaTiers = [1, 1.5, 2, 3, 4,5.5]
var speedTiers = [0.30, 0.50, 0.80, 1.00, 1.50, 2.00]
var capacityTiers = [100,150,275,400,600, 1000]
#Watering area upgrade tier
var area = 1
#Water fill rate upgrade tier
var speed = 1
#Max water capacity upgrade tier
var level = 1

var affectedPlants = []

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
		waterLevel = waterLevel + ((speedTiers[speed]/100.00)*waterCapacity)
		if waterLevel > waterCapacity:
			waterLevel = waterCapacity
			water_fill.stop()
		water_bar.value = waterLevel
	if releaseFlag:
		potRelease()
		releaseFlag = false

	#sitting on garden
	if draggable and !Global.placingItem and !dragging:
		if Input.is_action_just_pressed("LMB"):
			SignalBus.waterBarEnable.emit(true)
			SignalBus.mouseTooltip.emit("Hold: Water","", "RMB", "None", "", false, true)
			SignalBus.gridToggle.emit(true)
			pickup_sound.play()
			dragging = true
			offset1 = get_global_mouse_position()
			initialPosition = global_position
			Global.is_dragging = true
		if Input.is_action_just_pressed("RMB"):
			UIEnable()
	#Holding Watering Can
	if dragging and !Global.placingItem:
		if Input.is_action_pressed("LMB"):
			if waterLevel <= 0 and !outOfWaterFlag:
				SignalBus.outOfWater.emit(true)
				watering_sound.stop()
				water_particles.water(false)
				outOfWaterFlag = true
			offset2 = get_global_mouse_position() - offset1
			global_position.x = int(initialPosition.x/3)*3 + int(offset2.x/3)*3
			global_position.y = int(initialPosition.y/3)*3 + int(offset2.y/3)*3
		if Input.is_action_pressed("RMB") and !filling:
			if resetPosition:
				resetPosition = false
			if sprite_2d.rotation_degrees > -57:
				sprite_2d.rotation_degrees = lerp(sprite_2d.rotation_degrees,-57.00,delta)
				water_particles.setLifetime(lerp(water_particles.getLifetime(),0.4,delta))
				if sprite_2d.rotation_degrees < -40 and !watering:
					watering = true
					if waterLevel >0:
						water_particles.water(true)
						watering_sound.play()
					else:
						water_particles.water(false)
						watering_sound.stop()
		if Input.is_action_just_released("RMB"):
			resetPosition = true
		if resetPosition:
			sprite_2d.rotation_degrees = lerp(sprite_2d.rotation_degrees,0.00,delta*2)
			water_particles.setLifetime(lerp(water_particles.getLifetime(),0.6,delta))
			if sprite_2d.rotation_degrees > -40 and watering:
				watering_sound.stop()
				water_particles.water(false)
				watering = false
			if is_equal_approx(sprite_2d.rotation_degrees,0.00):
				resetPosition = false
		if watering and waterLevel > 0:
			pourWater(delta)


func pourWater(delta):
	waterLevel-= delta*20
	SignalBus.waterUsed.emit(delta*20)
	water_bar.value = waterLevel
	for x in affectedPlants:
		x.addWater()

func refill(enabled:bool):
	if enabled:
		sprite_2d.rotation_degrees = 0
		watering = false
		watering_sound.stop()
		water_particles.water(false)
		if waterLevel != waterCapacity:
			filling = true
			water_fill.play()
	else:
		filling = false
		water_fill.stop()

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		if dragging:
			watering_sound.stop()
			SignalBus.waterBarEnable.emit(false)
			sprite_2d.rotation_degrees = 0
			water_particles.water(false)
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
		SignalBus.waterBarEnable.emit(false)
		water_particles.water(false)
		outOfWaterFlag = false
		SignalBus.outOfWater.emit(false)
		SignalBus.gridToggle.emit(false)
		set_physics_process(false)


func _on_grab_area_mouse_entered():
	set_physics_process(true)
	processing = true
	if not Global.is_dragging:
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
	data.areaUpgrade = area
	data.capacityUpgrade = level
	data.fillUpgrade = speed
	data.r = red
	data.g = green
	data.b = blue
	return data

func loadState(data:waterCanData):
	global_position = data.position
	waterLevel = data.water
	setCapacity(data.capacityUpgrade)
	setEffectArea(data.areaUpgrade)
	setSpeedLevel(data.fillUpgrade)
	changeColour(data.r,data.g,data.b)
	watering_can_upgrade_ui.loadState(data)

func potRelease():
	watering = false
	watering_sound.stop()
	outOfWaterFlag = false
	SignalBus.waterBarEnable.emit(false)
	sprite_2d.rotation_degrees = 0
	water_particles.water(false)
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
	grab_area.refesh()


func setSpeedLevel(value:int):
	speed = value


func setCapacity(value:int):
	level = value
	waterCapacity = capacityTiers[level]
	water_bar.max_value = waterCapacity

func setEffectArea(value:int):
	area = value
	range_indicator.scale = Vector2(areaTiers[area],areaTiers[area])
	effect_collider.scale = Vector2(areaTiers[area],areaTiers[area])
	#water_particles.process_material.spawn.velocity.spread = areaTiers[value] * 28

func changeColour(r:float,g:float,b:float):
	red = r
	green = g
	blue = b
	sprite_2d.self_modulate.r = red
	sprite_2d.self_modulate.g = green
	sprite_2d.self_modulate.b = blue

func _on_refill_detect_body_entered(_body):
	refill(true)


func _on_refill_detect_body_exited(_body):
	refill(false)


func _on_effect_range_body_entered(body):
	affectedPlants.append(body)


func _on_effect_range_body_exited(body):
	affectedPlants.pop_at(affectedPlants.find(body))

func UIEnable():
	print_debug(global_position.y)
	watering_can_upgrade_ui.visible = !watering_can_upgrade_ui.visible
	watering_can_upgrade_ui.position.y = -64
	if global_position.y < 10:
		watering_can_upgrade_ui.global_position.y = -53
	#elif watering_can_upgrade_ui.global_position.y >= get_viewport_rect().size.y - 66:
	#	watering_can_upgrade_ui.global_position.y = get_viewport_rect().size.y - 67
