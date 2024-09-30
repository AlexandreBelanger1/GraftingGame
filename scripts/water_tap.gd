extends StaticBody2D
@onready var low_water_indicator = $LowWaterIndicator
@onready var blink_timer = $BlinkTimer

func _ready():
	SignalBus.outOfWater.connect(blinkIndicator)

func blinkIndicator(enabled:bool):
	if enabled:
		blink_timer.start()
	else:
		blink_timer.stop()
		low_water_indicator.visible = false



func _on_blink_timer_timeout():
	low_water_indicator.visible = !low_water_indicator.visible
