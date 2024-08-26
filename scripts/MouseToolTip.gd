extends Control
@onready var label = $Label

func setText(value:String):
	label.text = value

func _process(_delta):
	global_position.x = get_global_mouse_position().x - 30
	global_position.y = get_global_mouse_position().y -40
