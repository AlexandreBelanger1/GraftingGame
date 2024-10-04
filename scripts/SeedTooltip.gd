extends Control
@onready var tooltip_label = $Background/TooltipLabel
@onready var roots_label = $Background/RootsLabel
@onready var tooltip_label_2 = $Background/TooltipLabel2


func setTooltip(root:String, stem:String, flower:String, pSpecialType:String):
	tooltip_label.text = stem.trim_suffix("Stem")
	tooltip_label_2.text = flower.trim_suffix("Flower")
	roots_label.text = root
	print_debug(pSpecialType)
	if pSpecialType == "moon":
		modulate = Color(0.587, 0.666, 0.934)
	elif pSpecialType == "emerald":
		modulate = Color(0.329, 0.79, 0.428)
	elif pSpecialType == "rainbow":
		modulate = Color(0.836, 0.325, 0.486)
