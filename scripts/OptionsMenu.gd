extends Control



func _on_save_button_pressed():
	SignalBus.saveGame.emit()


func _on_load_button_pressed():
	SignalBus.loadGame.emit()
