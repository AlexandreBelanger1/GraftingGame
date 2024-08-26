extends Control
@onready var left_arrow = $LeftArea/LeftArrow
@onready var right_arrow = $RightArea/RightArrow
@onready var shop_button = $ShopButton
@onready var seeds_button = $SeedsButton
@onready var shop_UI = $ShopUI
@onready var place_pot_ui = $PlacePotUI
@onready var currency_counter = $CurrencyCounter
@onready var seeds_ui = $SeedsUI
@onready var options_menu = $OptionsMenu
@onready var button_hover = $ButtonHover
@onready var button_clicked = $ButtonClicked
@onready var spade_equip = $SpadeEquip
@onready var confirm_selection_ui = $ConfirmSelectionUI
@onready var mouse_tool_tip = $MouseToolTip


signal moveCameraLeft
signal stopCamera
signal moveCameraRight

func _ready():
	SignalBus.confirmUI.connect(enableConfirmUI)
	SignalBus.mouseTooltip.connect(setMouseTooltip)

func _input(event):
	if event.is_action_pressed("plantSeed"):
		placePotUI(false)
	if event.is_action_released("LMB"):
		if Global.placingItem == false:
			placePotUI(false)
	if event.is_action_pressed("options"):
		options_menu.visible = !options_menu.visible

func _on_left_area_mouse_entered():
	emit_signal("moveCameraLeft")
	left_arrow.visible = true


func _on_left_area_mouse_exited():
	emit_signal("stopCamera")
	left_arrow.visible = false


func _on_right_area_mouse_entered():
	emit_signal("moveCameraRight")
	right_arrow.visible = true

func _on_right_area_mouse_exited():
	emit_signal("stopCamera")
	right_arrow.visible = false


func _on_shop_button_pressed():
	button_clicked.play()
	seeds_ui.visible = false
	shop_UI.toggleVisible()


func placePotUI(enable: bool):
	place_pot_ui.visible = enable
	shop_button.visible = !enable
	seeds_button.visible = !enable

func updateCurrency():
	currency_counter.text = str(Global.gold)


func _on_seeds_button_pressed():
	button_clicked.play()
	seeds_ui.visible = !seeds_ui.visible
	shop_UI.setVisible(false)

func _on_options_button_pressed():
	button_clicked.play()
	options_menu.visible = !options_menu.visible


func _on_shop_button_mouse_entered():
	button_hover.play()


func _on_seeds_button_mouse_entered():
	button_hover.play()


func _on_options_button_mouse_entered():
	button_hover.play()


func _on_remove_plant_button_toggled(toggled_on):
	if toggled_on:
		SignalBus.setState.emit(2)
		spade_equip.play()
	else:
		SignalBus.setState.emit(1)

func enableConfirmUI():
	confirm_selection_ui.visible = true
	SignalBus.setTooltip.emit("null",0)
	SignalBus.mouseTooltip.emit("null")
	


func _on_remove_plant_button_mouse_entered():
	button_hover.play()

func setMouseTooltip(value:String):
	if value == "null":
		mouse_tool_tip.visible = false
	else:
		mouse_tool_tip.visible = true
		mouse_tool_tip.setText(value)
