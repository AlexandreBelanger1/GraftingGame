extends Control




func _on_cancel_button_pressed():
	SignalBus.confirmRemove.emit(false)
	self.visible = false


func _on_confirm_button_pressed():
	SignalBus.confirmRemove.emit(true)
	self.visible = false
