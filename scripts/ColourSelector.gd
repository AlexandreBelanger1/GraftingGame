extends Control
@onready var watering_can_white = $ColourSelector/WateringCanWhite



func _on_red_slider_value_changed(value):
	watering_can_white.self_modulate.r = value


func _on_green_slider_value_changed(value):
	watering_can_white.self_modulate.g = value


func _on_blue_slider_value_changed(value):
	watering_can_white.self_modulate.b = value


func _on_button_pressed():
	if Global.gold >= 100:
		SignalBus.addGold.emit(-100)
		get_parent().get_parent().changeColour(watering_can_white.self_modulate.r,watering_can_white.self_modulate.g,watering_can_white.self_modulate.b)
