extends Area2D

var refreshCollisionFlag = 0
func _physics_process(_delta):
	if refreshCollisionFlag == 0:
		set_physics_process(false)
	elif refreshCollisionFlag == 1:
		input_pickable = false
		refreshCollisionFlag = 2
	elif refreshCollisionFlag == 2:
		input_pickable = true
		refreshCollisionFlag = 0
		set_physics_process(false)

func refesh():
	refreshCollisionFlag = 1
	set_physics_process(true)
