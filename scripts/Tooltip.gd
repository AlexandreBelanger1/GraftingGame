extends Control
@onready var name_label = $Sprite2D/NameLabel
@onready var growth_label = $Sprite2D/GrowthLabel
@onready var sprite_2d = $Sprite2D
@onready var stem_progress = $Sprite2D/StemProgress
@onready var flower_progress = $Sprite2D/FlowerProgress
@onready var stem_growth_stat = $Sprite2D/StemGrowthStat
@onready var flower_growth_stat = $Sprite2D/FlowerGrowthStat
@onready var unlock_rate_stat = $Sprite2D/UnlockRateStat
@onready var sell_value_stat = $Sprite2D/SellValueStat



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

func setContents(name:String, stemGrowth: float, flowerGrowth: float, stat1: float, stat2: float, stat3: float, stat4: float):
	set_process(true)
	if name == "null":
		hideTooltip()
	else:
		sprite_2d.visible = true
		name_label.text = name
		stem_progress.value = int(stemGrowth*100)
		flower_progress.value = int(flowerGrowth*100)
		stem_growth_stat.value = stat1
		flower_growth_stat.value = stat2
		unlock_rate_stat.value = stat3
		sell_value_stat.value = stat4

func hideTooltip():
	sprite_2d.visible = false

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		set_process(false)
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		set_process(false)
