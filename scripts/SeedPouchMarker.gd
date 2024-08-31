extends Area2D

func _on_body_entered(body):
	print_debug("colliding!")
	body.collectSeed()


func _on_area_entered(area):
	print_debug("colliding!")
	area.collectSeed()
