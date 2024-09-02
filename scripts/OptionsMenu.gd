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


func _on_switch_window_button_pressed():
	if DisplayServer.get_screen_count() > 1:
		if DisplayServer.get_primary_screen() < DisplayServer.get_screen_count() - 1:
			swapWindow(DisplayServer.get_primary_screen()+1)
	print_debug(DisplayServer.get_screen_count())
	SignalBus.windowSetup.emit()

func swapWindow(value:int):
	pass


func _on_h_slider_value_changed(value):
	Global.gameSpeed = value
	SignalBus.changeGameSpeed.emit()
