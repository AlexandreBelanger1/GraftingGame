extends Control
@onready var left_arrow = $LeftArea/LeftArrow
@onready var right_arrow = $RightArea/RightArrow

signal moveCameraLeft
signal stopCamera
signal moveCameraRight

func _on_left_area_mouse_entered():
	emit_signal("moveCameraLeft")
	left_arrow.visible = true


func _on_left_area_mouse_exited():
	emit_signal("stopCamera")
	left_arrow.visible = false


func _on_right_area_mouse_entered():
	emit_signal("moveCameraRight")
	right_arrow.visible = true

func _on_right_area_mouse_exited():
	emit_signal("stopCamera")
	right_arrow.visible = false


