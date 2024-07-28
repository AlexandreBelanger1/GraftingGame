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
	direction = -1


func _on_player_ui_move_camera_right():
	direction = 1


func _on_player_ui_stop_camera():
	direction = 0
