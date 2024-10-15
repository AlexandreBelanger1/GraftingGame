extends Control

func _on_japanese_style_pressed():
	SignalBus.changeBackground.emit("Japanese")


func _on_floating_farm_style_pressed():
	SignalBus.changeBackground.emit("FloatingFarm")


func _on_void_style_pressed():
	SignalBus.changeBackground.emit("Void")


func _on_beach_style_pressed():
	SignalBus.changeBackground.emit("Beach")


func _on_simple_style_pressed():
	SignalBus.changeBackground.emit("Simple")
