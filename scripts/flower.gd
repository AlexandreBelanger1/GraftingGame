extends Node2D
@onready var sprite = $Sprite
@onready var growth_timer = $GrowthTimer

signal flowerComplete

var stats = flowerStats.new()

func startGrowth():
	sprite.visible = true
	growth_timer.start()

func _on_growth_timer_timeout():
	if sprite.frame == stats.growthFrames:
		growth_timer.stop()
		emit_signal("flowerComplete")
	else: 
		sprite.frame += 1

