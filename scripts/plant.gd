class_name plant extends Node2D
@onready var flower = $PansyFlower
@onready var roots = $PansyRoots
@onready var stem = $pansy_stem
@onready var currency_gen = $CurrencyGen





func _on_currency_gen_timeout():
	SignalBus.addGold.emit(1)
	print_debug("generatingGold!")
	print_debug(Global.gold)


func _on_pansy_stem_stem_complete():
	currency_gen.start()
	flower.visible = true
