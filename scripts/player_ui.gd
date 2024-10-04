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
@onready var confirm_selection_ui = $ConfirmSelectionUI
@onready var mouse_tool_tip = $MouseToolTip
@onready var seed_bag_ui = $SeedBagUI
@onready var sell_ui = $SellUI
@onready var options_label = $OptionsLabel
@onready var shop_label = $ShopLabel
@onready var seeds_label = $SeedsLabel




var UIhidden = false
signal moveCameraLeft
signal stopCamera
signal moveCameraRight

func _ready():
	SignalBus.confirmUI.connect(enableConfirmUI)


#CAMERA CONROLS
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


#UI BUTTON PRESSED
func _on_shop_button_pressed():
	shop_UI.visible = !shop_UI.visible
	seed_bag_ui.visible = false
	button_clicked.play()

func _on_seeds_button_pressed():
	seed_bag_ui.visible = !seed_bag_ui.visible
	shop_UI.visible = false
	button_clicked.play()

func _on_options_button_pressed():
	button_clicked.play()
	options_menu.visible = !options_menu.visible


#UI BUTTON ENTERED
func _on_shop_button_mouse_entered():
	button_hover.play()
	shop_label.visible = true

func _on_seeds_button_mouse_entered():
	button_hover.play()
	seeds_label.visible = true

func _on_options_button_mouse_entered():
	button_hover.play()
	options_label.visible = true


#UI BUTTON EXITED
func _on_seeds_button_mouse_exited():
	seeds_label.visible = false

func _on_shop_button_mouse_exited():
	shop_label.visible = false

func _on_options_button_mouse_exited():
	options_label.visible = false


#OTHER FUNCTIONS
func updateCurrency():
	currency_counter.text = str(Global.gold)

func enableConfirmUI():
	confirm_selection_ui.visible = true
	SignalBus.setTooltip.emit("null",0,0,0,0,0,0)
	SignalBus.mouseTooltip.emit("","","None","None","",false,false)
