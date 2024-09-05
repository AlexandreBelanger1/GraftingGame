extends Control
@onready var left_arrow = $LeftArea/LeftArrow
@onready var right_arrow = $RightArea/RightArrow
@onready var shop_button = $ShopButton
@onready var seeds_button = $SeedsButton
@onready var shop_UI = $ShopUI
@onready var currency_counter = $CurrencyCounter
@onready var options_menu = $OptionsMenu
@onready var button_hover = $ButtonHover
@onready var button_clicked = $ButtonClicked
@onready var spade_equip = $SpadeEquip
@onready var confirm_selection_ui = $ConfirmSelectionUI
@onready var mouse_tool_tip = $MouseToolTip
@onready var seed_bag_ui = $SeedBagUI
@onready var pots_ui = $PotsUI



var UIhidden = false
signal moveCameraLeft
signal stopCamera
signal moveCameraRight

func _ready():
	SignalBus.confirmUI.connect(enableConfirmUI)
	
	

func _input(event):
	pass

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


func _on_pots_button_pressed():
	Global.state = 1
	button_clicked.play()
	seed_bag_ui.visible = false
	shop_UI.visible = false
	pots_ui.toggleVisible()



func updateCurrency():
	currency_counter.text = str(Global.gold)


func _on_seeds_button_pressed():
	seed_bag_ui.visible = !seed_bag_ui.visible
	if seed_bag_ui.visible:
		Global.state = 3
	else:
		Global.state = 1
	button_clicked.play()
	shop_UI.visible = false
	pots_ui.setVisible(false)

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
		Global.state = 4
		spade_equip.play()
		pots_ui.setVisible(false)
		seed_bag_ui.visible = false
		shop_UI.visible = false
	else:
		SignalBus.setState.emit(1)
		Global.state = 1


func enableConfirmUI():
	confirm_selection_ui.visible = true
	SignalBus.setTooltip.emit("null",0)
	SignalBus.mouseTooltip.emit("null")
	


func _on_remove_plant_button_mouse_entered():
	button_hover.play()




func _on_shop_button_pressed():
	shop_UI.visible = !shop_UI.visible
	pots_ui.setVisible(false)
	seed_bag_ui.visible = false
	button_clicked.play()
	Global.state = 1
