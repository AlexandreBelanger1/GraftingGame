extends Control
@onready var root_select = $RootSelect
@onready var stem_select = $StemSelect
@onready var flower_select = $FlowerSelect

func startSelection():
	root_select.visible = true

func nextStep(currentStep: int):
	if currentStep == 1:
		stem_select.visible = true
		root_select.visible = false
	elif currentStep == 2:
		stem_select.visible = false
		flower_select.visible = true
	elif currentStep == 3:
		flower_select.visible = false


func _on_bonsai_roots_button_pressed():
	Global.plantRoots = "bonsaiRoots"
	nextStep(1)


func _on_medium_roots_button_pressed():
	Global.plantRoots = "mediumRoots"
	nextStep(1)

func _on_small_roots_button_pressed():
	Global.plantRoots = "smallRoots"
	nextStep(1)

func _on_bonsai_stem_button_pressed():
	Global.plantStem = "bonsaiStem"
	nextStep(2)


func _on_cactus_stem_button_pressed():
	Global.plantStem = "cactusStem"
	nextStep(2)

func _on_pansy_stem_button_pressed():
	Global.plantStem = "pansyStem"
	nextStep(2)

func _on_sunflower_stem_button_pressed():
	Global.plantStem = "sunflowerStem"
	nextStep(2)

func _on_sunflower_flower_button_pressed():
	Global.plantFlower = "sunflowerFlower"
	nextStep(3)

func _on_pansy_flower_button_pressed():
	Global.plantFlower = "pansyFlower"
	nextStep(3)

func _on_cactus_flower_button_pressed():
	Global.plantFlower = "cactusFlower"
	nextStep(3)
