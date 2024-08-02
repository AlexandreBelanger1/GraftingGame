extends Control
@onready var left_arrow = $LeftArea/LeftArrow
@onready var right_arrow = $RightArea/RightArrow
@onready var shop_button = $ShopButton
@onready var seeds_button = $SeedsButton
@onready var shop_panel = $SeedsButton/ShopPanel
@onready var place_pot_ui = $PlacePotUI


signal moveCameraLeft
signal stopCamera
signal moveCameraRight

func _input(event):
	if event.is_action_pressed("plantSeed"):
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
	shop_panel.visible = !shop_panel.visible


func _on_small_pot_pressed():
	shop_panel.visible = false
	placePotUI(true)
	Global.is_dragging = true
	Global.placingItem = true


const MEDIUM_POT = preload("res://Scenes/Pots/MediumPot.tscn")
func _on_medium_pot_pressed():
	shop_panel.visible = false
	placePotUI(true)
	Global.is_dragging = true
	Global.placingItem = true
	var medPot = MEDIUM_POT.instantiate()
	get_parent().get_parent().add_child(medPot)
	medPot.potSetup()

func placePotUI(enable: bool):
	place_pot_ui.visible = enable
	shop_button.visible = !enable
	seeds_button.visible = !enable
