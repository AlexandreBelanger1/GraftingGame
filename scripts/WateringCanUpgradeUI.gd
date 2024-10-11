extends Control
@onready var area_button = $ColorRect/AreaFrame/AreaButton
@onready var level_button = $ColorRect/LevelFrame/LevelButton
@onready var speed_button = $ColorRect/SpeedFrame/SpeedButton
@onready var colour_button = $ColorRect/AnimatedSprite2D/ColourButton


@onready var price_label = $ColorRect/PriceLabel
@onready var area_frame = $ColorRect/AreaFrame
@onready var level_frame = $ColorRect/LevelFrame
@onready var speed_frame = $ColorRect/SpeedFrame
@onready var hover_sound = $HoverSound
@onready var press_sound = $PressSound



func _on_area_button_mouse_entered():
	if !area_button.disabled:
		price_label.visible = true
		price_label.text = Global.WateringCanUpgradePrices[area_frame.frame]
		hover_sound.play()


func _on_level_button_mouse_entered():
	if !level_button.disabled:
		price_label.visible = true
		price_label.text = Global.WateringCanUpgradePrices[level_frame.frame + 4]
		hover_sound.play()


func _on_speed_button_mouse_entered():
	if !speed_button.disabled:
		price_label.visible = true
		price_label.text = Global.WateringCanUpgradePrices[speed_frame.frame + 9]
		hover_sound.play()


func _on_colour_button_mouse_entered():
	price_label.visible = true
	price_label.text = Global.WateringCanUpgradePrices[15]
	hover_sound.play()


func _on_area_button_mouse_exited():
	price_label.visible = false


func _on_level_button_mouse_exited():
	price_label.visible = false


func _on_speed_button_mouse_exited():
	price_label.visible = false


func _on_colour_button_mouse_exited():
	price_label.visible = false


func _on_area_button_pressed():
	if Global.gold >= int(Global.WateringCanUpgradePrices[area_frame.frame]):
		Global.gold -= int(Global.WateringCanUpgradePrices[area_frame.frame])
		press_sound.play()
		area_frame.frame += 1
		price_label.text = Global.WateringCanUpgradePrices[area_frame.frame]
		if area_frame.frame == 5:
			area_button.disabled = true
			price_label.visible = false


func _on_level_button_pressed():
	if Global.gold >= int(Global.WateringCanUpgradePrices[level_frame.frame + 5]):
		Global.gold -= int(Global.WateringCanUpgradePrices[level_frame.frame + 5])
		press_sound.play()
		level_frame.frame += 1
		price_label.text = Global.WateringCanUpgradePrices[level_frame.frame + 5]
		if level_frame.frame == 5:
			level_button.disabled = true
			price_label.visible = false


func _on_speed_button_pressed():
	if Global.gold >= int(Global.WateringCanUpgradePrices[speed_frame.frame + 10]):
		Global.gold -= int(Global.WateringCanUpgradePrices[speed_frame.frame + 10])
		press_sound.play()
		speed_frame.frame += 1
		price_label.text = Global.WateringCanUpgradePrices[speed_frame.frame + 10]
		get_parent().setSpeedLevel(speed_frame.frame + 1)
		if speed_frame.frame == 5:
			speed_button.disabled = true
			price_label.visible = false


func _on_colour_button_pressed():
	press_sound.play()

func _unhandled_input(event):
	if event.is_action_pressed("LMB"):
		visible = false
