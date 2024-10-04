extends Control

@onready var borderless_button = $BorderlessButton
@onready var credits = $Credits
@onready var confirm_new_save = $ConfirmNewSave


func _on_save_button_pressed():
	SignalBus.saveGame.emit()


func _on_load_button_pressed():
	SignalBus.loadGame.emit()


func _on_new_save_button_pressed():
	confirm_new_save.visible = true


func _on_mobile_controls_button_pressed():
	Global.mobileControls = !Global.mobileControls


func _on_quit_button_pressed():
	get_tree().quit()


func _on_h_slider_value_changed(value):
	Global.gameSpeed = value
	SignalBus.changeGameSpeed.emit()


func _on_borderless_button_pressed():
	if borderless_button.button_pressed:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

func _on_fit_window_button_pressed():
	SignalBus.windowSetup.emit()


func _on_sfx_slider_value_changed(value):
	var sfx_index= AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_index, linear_to_db(value))


func _on_music_slider_value_changed(value):
	var music_index= AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_index, linear_to_db(value))


func _on_credits_button_pressed():
	credits.visible = !credits.visible


func _on_confirm_no_pressed():
	confirm_new_save.visible = false


func _on_confirm_yes_pressed():
	confirm_new_save.visible = false
	SignalBus.newSaveGame.emit()
