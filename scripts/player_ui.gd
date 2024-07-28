extends Control

signal moveCameraLeft
signal stopCamera
signal moveCameraRight

func _on_left_area_mouse_entered():
	emit_signal("moveCameraLeft")


func _on_left_area_mouse_exited():
	emit_signal("stopCamera")


func _on_right_area_mouse_entered():
	emit_signal("moveCameraRight")


func _on_right_area_mouse_exited():
	emit_signal("stopCamera")



