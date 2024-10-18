extends Camera2D
var direction = 0
var speed = 1

func _physics_process(_delta):
	if Input.is_action_pressed("LMB"):
		speed = 2
	if Input.is_action_just_released("LMB"):
		speed = 1
	global_position.x += direction * speed

func _on_player_ui_move_camera_left():
	if global_position.x <= limit_left:
		direction = 0
		print_debug("cannot move left!")
	else:
		direction = -1
		print_debug("moving left!")


func _on_player_ui_move_camera_right():
	if global_position.x >= limit_right:
		direction = 0
	else:
		direction = 1


func _on_player_ui_stop_camera():
	direction = 0

