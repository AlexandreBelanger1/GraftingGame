extends Node2D
var machineType = "Greenhouse"
@export var greenhouseModifierType1 = "StemGrowthRate"
@export var greenhouseModifierMagnitude1 = 1.5
@export var greenhouseModifierType2 = "FlowerGrowthRate"
@export var greenhouseModifierMagnitude2 = 1.5


func save(index:int):
	if index == 1:
		return machineType


func _on_effect_range_body_entered(body):
	body.addModifier(greenhouseModifierType1,greenhouseModifierMagnitude1)
	body.addModifier(greenhouseModifierType2,greenhouseModifierMagnitude2)


func _on_effect_range_body_exited(body):
	body.removeModifier(greenhouseModifierType1,greenhouseModifierMagnitude1)
	body.removeModifier(greenhouseModifierType2,greenhouseModifierMagnitude2)
