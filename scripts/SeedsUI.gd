extends Control

@onready var custom_menu = $CustomMenu


@onready var unlock_button = $UnlockButton
@onready var unlock_button_2 = $UnlockButton2

@onready var sunflower_button = $sunflowerButton
@onready var chive_button = $chiveButton
@onready var pepper_button = $PepperButton
@onready var bonsai_button = $bonsaiButton


var seed1Price = 0
var seed2Price = 0
var seed3Price = 50000
var seed4Price = 500000



func _on_pansy_button_pressed():
	Global.plantFlower = "pansyFlower"
	Global.plantRoots= "mediumRoots"
	Global.plantStem= "pansyStem"


func _on_cactus_button_pressed():
	Global.plantFlower = "cactusFlower"
	Global.plantRoots= "smallRoots"
	Global.plantStem= "cactusStem"


func _on_hybrid_button_pressed():
	Global.plantFlower = "pansyFlower"
	Global.plantRoots= "mediumRoots"
	Global.plantStem= "cactusStem"


func _on_unlock_button_pressed():
	if Global.gold >= seed1Price:
		unlock_button.visible = false
		sunflower_button.visible = true


func _on_unlock_button_2_pressed():
	if Global.gold >= seed2Price:
		unlock_button_2.visible = false
		chive_button.visible = true


func _on_sunflower_button_pressed():
	Global.plantFlower = "sunflowerFlower"
	Global.plantRoots= "mediumRoots"
	Global.plantStem= "sunflowerStem"


func _on_bonsai_button_pressed():
	Global.plantFlower = "null"
	Global.plantRoots= "bonsaiRoots"
	Global.plantStem= "bonsaiStem"


func _on_custom_button_pressed():
	custom_menu.startSelection()


func _on_chive_button_pressed():
	Global.plantFlower = "chiveFlower"
	Global.plantRoots= "mediumRoots"
	Global.plantStem= "chiveStem"
