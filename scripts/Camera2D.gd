extends Camera2D

@onready var left_arrow = $LeftArea/LeftArrow
@onready var left_arrow_2 = $LeftArea/LeftArrow2
@onready var right_arrow_2 = $RightArea/RightArrow2
@onready var right_arrow = $RightArea/RightArrow
@onready var buy_left_button = $LeftArea/BuyLeftButton
@onready var buy_right_button = $RightArea/BuyRightButton


var speed = 5
var targetPosition = 0.00
var movingLeft = false
var movingRight = false
var leftLimit = -100.00
var rightLimit = 100.00
var limitArray = [0,150,300,450,600]
var priceArray = [1000,5000,25000,80000,320000]
var rightUpgradeTier = 0
var leftUpgradeTier = 0

func _input(event):
	if event.is_action_pressed("RMB") and movingLeft and !buy_left_button.visible:
		speed = 10
		left_arrow_2.visible = true
	elif event.is_action_pressed("RMB") and movingRight and !buy_right_button.visible:
		speed = 10
		right_arrow_2.visible = true
	elif event.is_action_released("RMB"):
		speed = 5
		right_arrow_2.visible = false
		left_arrow_2.visible = false


func _physics_process(delta):
	if movingLeft and targetPosition > leftLimit:
		targetPosition = lerp(targetPosition,targetPosition-10.00,delta*speed)
	elif movingRight and targetPosition < rightLimit:
		targetPosition = lerp(targetPosition,targetPosition+10.00,delta*speed)
	if targetPosition <= leftLimit and movingLeft:#is_equal_approx(targetPosition,leftLimit):
		left_arrow.visible = false
		left_arrow_2.visible = false
		buy_left_button.visible = true
		buy_left_button.text = str(priceArray[leftUpgradeTier])
	if targetPosition >=  rightLimit and movingRight:#is_equal_approx(targetPosition,rightLimit):
		right_arrow.visible = false
		right_arrow_2.visible = false
		buy_right_button.visible = true
		buy_right_button.text = str(priceArray[rightUpgradeTier])
	if is_equal_approx(targetPosition,global_position.x):
		set_physics_process(false)
	global_position.x  = lerp(targetPosition,global_position.x, delta*speed)


func _on_left_area_mouse_entered():
	if Input.is_action_pressed("RMB"):
		left_arrow_2.visible = true
		speed = 10
	movingLeft = true
	left_arrow.visible = true
	set_physics_process(true)


func _on_right_area_mouse_entered():
	if Input.is_action_pressed("RMB"):
		right_arrow_2.visible = true
		speed = 10
	movingRight = true
	right_arrow.visible = true
	set_physics_process(true)

func _on_right_area_mouse_exited():
	movingRight = false
	right_arrow.visible = false
	right_arrow_2.visible = false
	buy_right_button.visible = false

func _on_left_area_mouse_exited():
	movingLeft = false
	left_arrow.visible = false
	left_arrow_2.visible = false
	buy_left_button.visible = false


func _on_buy_left_button_pressed():
	if Global.gold >= priceArray[leftUpgradeTier]:
		buy_left_button.visible = false
		left_arrow.visible = true
		if Input.is_action_pressed("RMB"):
			left_arrow_2.visible = true
			speed = 10
		SignalBus.removeGold.emit(priceArray[leftUpgradeTier])
		leftUpgradeTier += 1
		leftLimit -= 150
		set_physics_process(true)


func _on_buy_right_button_pressed():
	if Global.gold >= priceArray[rightUpgradeTier]:
		buy_right_button.visible = false
		if Input.is_action_pressed("RMB"):
			right_arrow_2.visible = true
			speed = 10
		right_arrow.visible = true
		SignalBus.removeGold.emit(priceArray[rightUpgradeTier])
		rightUpgradeTier += 1
		rightLimit += 150
		set_physics_process(true)

func save(value:int):
	if value == 1:
		return leftUpgradeTier
	elif value == 2:
		return rightUpgradeTier

func load(value:int, tier:int):
	if value == 1:
		leftUpgradeTier = tier
		leftLimit = -limitArray[tier]
	elif value == 2:
		rightUpgradeTier = tier
		rightLimit = limitArray[tier]
