extends Control
@onready var text_1 = $Text1
@onready var text_2 = $Text2

@onready var animation_player = $AnimationPlayer
@onready var mouse_animation = $MouseAnimation
@onready var mouse_animation_2 = $MouseAnimation2
@onready var requirement_label = $RequirementLabel


func _ready():
	SignalBus.mouseTooltip.connect(setMouseTooltip)

func _process(_delta):
	global_position.x = get_global_mouse_position().x - 30
	global_position.y = get_global_mouse_position().y -40

func setMouseTooltip(text1:String,text2: String, image1:String, image2:String, requirementText:String, requirementPlay:bool, enable:bool):
	if enable:
		set_process(true)
		modulate.a = 1
		text_1.text = text1
		text_2.text = text2
		mouse_animation.animation = image1
		mouse_animation.play()
		mouse_animation_2.animation = image2
		mouse_animation_2.play()
		if !animation_player.is_playing():
			requirement_label.text = requirementText
		if requirementPlay:
			animation_player.play("Requirement")
	else:
		set_process(false)
		modulate.a = 0
		if animation_player.is_playing():
			modulate.a = 1
			text_1.text = ""
			text_2.text = ""
			mouse_animation.animation = "None"
			mouse_animation.play()
			mouse_animation_2.animation = "None"
			mouse_animation_2.play()

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		set_process(false)
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		set_process(false)
