extends Control



func _on_save_button_pressed():
	SignalBus.saveGame.emit()


func _on_load_button_pressed():
	SignalBus.loadGame.emit()


func _on_new_save_button_pressed():
	SignalBus.newSaveGame.emit()


func _on_mobile_controls_button_pressed():
	Global.mobileControls = !Global.mobileControls


func _on_quit_button_pressed():
	get_tree().quit()
