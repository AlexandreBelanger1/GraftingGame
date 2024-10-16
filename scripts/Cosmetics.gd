extends Control

#Decorations
const GODOT_PLUSHIE = preload("res://Scenes/Decorations/GodotPlushie.tscn")




#Map Theme buttons
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

#Decoration Buttons
func _on_godot_plushie_pressed():
	if Global.gold >= Global.decorationPrices["GodotPlushie"] and !Global.is_dragging:
		SignalBus.mouseTooltip.emit("Place","Cancel", "LMB", "RMB", "", false, true)
		SignalBus.gridToggle.emit(true)
		Global.is_dragging = true
		Global.placingItem = true
		var newDecoration = GODOT_PLUSHIE.instantiate()
		get_parent().get_parent().get_parent().add_child(newDecoration)
		newDecoration.setup("GodotPlushie")
		SignalBus.removeGold.emit(Global.decorationPrices["GodotPlushie"])
		Global.itemCost = Global.decorationPrices["GodotPlushie"]
