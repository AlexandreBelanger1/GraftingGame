extends Control
@onready var shop_button = $ShopButton
@onready var seeds_button = $SeedsButton
@onready var cosmetics_button = $CosmeticsButton

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
@onready var cosmetics = $Cosmetics
@onready var cosmetics_label = $CosmeticsLabel
@onready var stats_label = $StatsLabel
@onready var stats = $Stats




var UIhidden = false


func _ready():
	SignalBus.confirmUI.connect(enableConfirmUI)


#UI BUTTON PRESSED
func _on_shop_button_pressed():
	shop_UI.visible = !shop_UI.visible
	seed_bag_ui.visible = false
	cosmetics.visible = false
	button_clicked.play()

func _on_seeds_button_pressed():
	seed_bag_ui.visible = !seed_bag_ui.visible
	shop_UI.visible = false
	cosmetics.visible = false
	button_clicked.play()

func _on_options_button_pressed():
	button_clicked.play()
	options_menu.visible = !options_menu.visible
	stats.visible = false

func _on_cosmetics_button_pressed():
	button_clicked.play()
	seed_bag_ui.visible = false
	shop_UI.visible = false
	cosmetics.visible = !cosmetics.visible

func _on_stats_button_pressed():
	SignalBus.updateTimeStats.emit()
	button_clicked.play()
	options_menu.visible = false
	stats.visible = !stats.visible

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

func _on_cosmetics_button_mouse_entered():
	button_hover.play()
	cosmetics_label.visible = true

func _on_stats_button_mouse_entered():
	button_hover.play()
	stats_label.visible = true


#UI BUTTON EXITED
func _on_seeds_button_mouse_exited():
	seeds_label.visible = false

func _on_shop_button_mouse_exited():
	shop_label.visible = false

func _on_options_button_mouse_exited():
	options_label.visible = false

func _on_cosmetics_button_mouse_exited():
	cosmetics_label.visible = false

func _on_stats_button_mouse_exited():
	stats_label.visible = false

#OTHER FUNCTIONS
func updateCurrency():
	currency_counter.text = str(Global.gold)

func enableConfirmUI():
	confirm_selection_ui.visible = true
	SignalBus.setTooltip.emit("null",0,0,0,0,0,0)
	SignalBus.mouseTooltip.emit("","","None","None","",false,false)
