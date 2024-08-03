extends Node2D
@onready var pansy_stem = $PansyStem
@onready var grow_timer = $GrowTimer


signal stemComplete


func _on_grow_timer_timeout():
	pansy_stem.frame +=1
	if pansy_stem.frame == 31:
		grow_timer.stop()
		emit_signal("stemComplete")
