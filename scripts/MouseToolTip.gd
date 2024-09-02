extends Control
@onready var label = $Label
@onready var animation_player = $AnimationPlayer
@onready var mouse_lmb = $MouseLmb

func _ready():
	SignalBus.mouseTooltip.connect(setMouseTooltip)


func setText(value:String):
	label.text = value

func _process(_delta):
	global_position.x = get_global_mouse_position().x - 30
	global_position.y = get_global_mouse_position().y -40

func setMouseTooltip(value:String):
	if value == "null":
		label.visible = false
		mouse_lmb.visible = false
	elif value == "potRequirement":
		animation_player.play("PotRequirement")
	else:
		label.visible = true
		mouse_lmb.visible = true
		setText(value)