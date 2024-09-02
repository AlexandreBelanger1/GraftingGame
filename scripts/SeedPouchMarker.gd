extends Area2D

func _on_body_entered(body):
	body.collectSeed()


func _on_area_entered(area):
	area.collectSeed()
