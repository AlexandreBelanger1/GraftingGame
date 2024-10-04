extends Control
@onready var button_hover = $ButtonHover
@onready var harvest_label = $Background/HarvestLabel
@onready var sell_label = $Background/SellLabel


func _on_sell_button_pressed():
	get_parent().get_parent().sellPlant()


func _on_harvestbutton_pressed():
	get_parent().get_parent().harvestPlant()


func _on_harvestbutton_mouse_entered():
	button_hover.play()
	harvest_label.visible = true


func _on_harvestbutton_mouse_exited():
	harvest_label.visible = false


func _on_sell_button_mouse_entered():
	button_hover.play()
	sell_label.visible = true


func _on_sell_button_mouse_exited():
	sell_label.visible = false
