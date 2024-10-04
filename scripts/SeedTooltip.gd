extends Control
@onready var tooltip_label = $Background/TooltipLabel
@onready var roots_label = $Background/RootsLabel


func setTooltip(root:String, stem:String, flower:String, pSpecialType:String):
	if stem.trim_suffix("Stem") != flower.trim_suffix("Flower"):
		tooltip_label.text = stem.trim_suffix("Stem") + "/" +flower.trim_suffix("Flower") + " hybrid"
	else:
		tooltip_label.text = "pure " + stem.trim_suffix("Stem")
	roots_label.text = root
	if pSpecialType == "moon":
		modulate = Color(0.587, 0.666, 0.934)
	elif pSpecialType == "emerald":
		modulate = Color(0.329, 0.79, 0.428)
	elif pSpecialType == "rainbow":
		modulate = Color(0.836, 0.325, 0.486)
