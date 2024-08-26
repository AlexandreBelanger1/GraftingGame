extends Control
@onready var name_label = $Sprite2D/NameLabel
@onready var growth_label = $Sprite2D/GrowthLabel
@onready var sprite_2d = $Sprite2D

func _ready():
	SignalBus.setTooltip.connect(setContents)

func _process(_delta):
	if get_global_mouse_position().y >= get_viewport_rect().size.y - 128:
		global_position.y = get_viewport_rect().size.y - 256
	elif get_global_mouse_position().y <= 128:
		global_position.y = 0
	else:
		global_position.y = get_global_mouse_position().y - 128
	if get_global_mouse_position().x >= get_viewport_rect().size.x/2:
		global_position.x = get_global_mouse_position().x - 300
	else:
		global_position.x = get_global_mouse_position().x +64

func setContents(name:String, growth: float):
	if name == "null":
		hideTooltip()
	else:
		sprite_2d.visible = true
		name_label.text = name
		growth_label.text = "progress: " + str(int(growth*100)) + "%"

func hideTooltip():
	sprite_2d.visible = false
