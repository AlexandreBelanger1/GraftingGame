class_name plant extends Node2D
@onready var flower = $PansyFlower
@onready var roots = $PansyRoots
@onready var stem = $pansy_stem
@onready var currency_gen = $CurrencyGen


func setup():
	pass


func _on_currency_gen_timeout():
	SignalBus.addGold.emit(1)


func _on_pansy_stem_stem_complete():
	flower.startGrowth()


func _on_pansy_flower_flower_complete():
	currency_gen.start()
