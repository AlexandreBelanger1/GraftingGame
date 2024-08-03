extends Node2D

var draggable = false
var dragging = false
var overlap = 0
var initialPosition
var offset1
var offset2
var Plant

func _process(delta):
	#Mode 1: placving from shop
	if Global.placingItem and dragging:
		offset2 = get_global_mouse_position() - offset1
		global_position = initialPosition + offset2
		if Input.is_action_just_pressed("LMB"):
			if overlap == 1:
				dragging = false
				Global.is_dragging = false
				Global.placingItem = false
		if Input.is_action_just_pressed("plantSeed"):
			Global.is_dragging = false
			Global.placingItem = false
			SignalBus.addGold.emit(Global.itemCost)
			queue_free()
			#refund cost
	#Mode 2: sitting on desk	
	if draggable:
		if Input.is_action_just_pressed("LMB"):
			dragging = true
			offset1 = get_global_mouse_position()
			initialPosition = global_position
			Global.is_dragging = true
		if Input.is_action_just_pressed("plantSeed") and !dragging:
			if Plant == null:
				newPlant()
	#Mode 3: moving existing pot
	if dragging and !Global.placingItem:
		if Input.is_action_pressed("LMB"):
			offset2 = get_global_mouse_position() - offset1
			global_position = initialPosition + offset2
		
		if Input.is_action_just_released("LMB"):
			if overlap != 1:
				global_position = initialPosition
			dragging = false
			Global.is_dragging = false
	



func _on_grab_area_mouse_entered():
	if not Global.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)


func _on_grab_area_mouse_exited():
	if not Global.is_dragging:
		draggable = false
		scale = Vector2(1,1)


func _on_grab_area_body_entered(body):
	overlap += 1


func _on_grab_area_body_exited(body):
	overlap -= 1


const PLANT = preload("res://Scenes/plant.tscn")
func newPlant():
	Plant = PLANT.instantiate()
	add_child(Plant)
	Plant.global_position = global_position

func potSetup():
	initialPosition = get_global_mouse_position()
	offset1 = get_global_mouse_position()
	dragging = true
