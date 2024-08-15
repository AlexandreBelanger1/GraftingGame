extends Control
@onready var left_arrow = $LeftArea/LeftArrow
@onready var right_arrow = $RightArea/RightArrow
@onready var shop_button = $ShopButton
@onready var seeds_button = $SeedsButton
@onready var shop_panel = $SeedsButton/ShopPanel
@onready var place_pot_ui = $PlacePotUI
@onready var currency_counter = $CurrencyCounter
@onready var seeds_ui = $SeedsUI


signal moveCameraLeft
signal stopCamera
signal moveCameraRight

var shopPrices ={"medium_pot": 10,"small_pot": 5, "bonsai_pot": 10}


func _input(event):
	if event.is_action_pressed("plantSeed"):
		placePotUI(false)
	if event.is_action_released("LMB"):
		if Global.placingItem == false:
			placePotUI(false)

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
	seeds_ui.visible = false
	shop_panel.visible = !shop_panel.visible

const SMALL_POT = preload("res://Scenes/Pots/SmallPot.tscn")
func _on_small_pot_pressed():
	if Global.gold >= shopPrices["small_pot"]:
		shop_panel.visible = false
		placePotUI(true)
		Global.is_dragging = true
		Global.placingItem = true
		var smallPot = SMALL_POT.instantiate()
		get_parent().get_parent().add_child(smallPot)
		smallPot.potSetup("smallPot")
		SignalBus.removeGold.emit(shopPrices["small_pot"])
		Global.itemCost = shopPrices["small_pot"]


const MEDIUM_POT = preload("res://Scenes/Pots/MediumPot.tscn")
func _on_medium_pot_pressed():
	if Global.gold >= shopPrices["medium_pot"]:
		shop_panel.visible = false
		placePotUI(true)
		Global.is_dragging = true
		Global.placingItem = true
		var medPot = MEDIUM_POT.instantiate()
		get_parent().get_parent().add_child(medPot)
		medPot.potSetup("mediumPot")
		SignalBus.removeGold.emit(shopPrices["medium_pot"])
		Global.itemCost = shopPrices["medium_pot"]

func placePotUI(enable: bool):
	place_pot_ui.visible = enable
	shop_button.visible = !enable
	seeds_button.visible = !enable

func updateCurrency():
	currency_counter.text = str(Global.gold)


func _on_seeds_button_pressed():
	seeds_ui.visible = !seeds_ui.visible
	shop_panel.visible = false

const BONSAI_POT = preload("res://Scenes/Pots/BonsaiPot.tscn")
func _on_bonsai_pot_2_pressed():
	if Global.gold >= shopPrices["bonsai_pot"]:
		shop_panel.visible = false
		placePotUI(true)
		Global.is_dragging = true
		Global.placingItem = true
		var bonsaiPot = BONSAI_POT.instantiate()
		get_parent().get_parent().add_child(bonsaiPot)
		bonsaiPot.potSetup("bonsaiPot")
		SignalBus.removeGold.emit(shopPrices["bonsai_pot"])
		Global.itemCost = shopPrices["bonsai_pot"]
