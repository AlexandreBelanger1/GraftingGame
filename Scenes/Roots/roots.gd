extends Node2D
@onready var sprite_2d = $Sprite2D


func _on_hitbox_mouse_entered():
	sprite_2d.visible = true


func _on_hitbox_mouse_exited():
	sprite_2d.visible = false
