extends Control

@onready var image_dict = $ImageDict
@onready var count = $Count


func setImage(value:String):
	image_dict.play(value)

func setCount(value:int):
	count.text = str(value)
