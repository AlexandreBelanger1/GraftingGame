extends Node2D
@onready var blend_timer = $BlendTimer
@onready var song_1 = $Song1
@onready var song_2 = $Song2


var songList
var Song1
var Song2
var Song3
var cycleNumber = 1

func _ready():
	set_physics_process(false)
	songList = [song_1, song_2]
	start()

func start():
	Song1 = songList.pick_random()
	queueSong()
	Song1.set_volume_db(0.00)
	Song2.set_volume_db(-80.00)
	Song1.play()
	blend_timer.wait_time = Song1.stream.get_length() - 5
	blend_timer.start()

func queueSong():
	if cycleNumber == 1:
		Song2 = Song1
		while Song2 == Song1 and songList.size() > 1:
			Song2 = songList.pick_random()
	if cycleNumber == 2:
		Song3 = Song2
		while Song3 == Song2 and songList.size() > 1:
			Song3 = songList.pick_random()
	if cycleNumber == 3:
		Song1 = Song3
		while Song1 == Song3 and songList.size() > 1:
			Song1 = songList.pick_random()

func _on_blend_timer_timeout():
	print_debug()
	if cycleNumber == 1:
		#Song2.set_volume_db(-80.00)
		Song2.play()
		blend_timer.wait_time = Song2.stream.get_length() - 2
		set_physics_process(true)
	if cycleNumber == 2:
		#Song3.set_volume_db(-80.00)
		Song3.play()
		blend_timer.wait_time = Song3.stream.get_length() - 2
		set_physics_process(true)
	if cycleNumber == 3:
		#Song1.set_volume_db(-80.00)
		Song1.play()
		blend_timer.wait_time = Song1.stream.get_length() - 2
		set_physics_process(true)
	blend_timer.start()

func _physics_process(delta):
	if cycleNumber == 1:
		Song1.set_volume_db(lerp(Song1.get_volume_db(), -80.00, delta/2))
		Song2.set_volume_db(lerp(Song2.get_volume_db(), 0.00, delta))
		if is_equal_approx(0.00,Song2.get_volume_db()) and is_equal_approx(-80.00,Song1.get_volume_db()):
			cycleNumber = 2
			print_debug("fade complete!")
			queueSong()
			set_physics_process(false)
	elif cycleNumber == 2:
		Song2.set_volume_db(lerp(Song2.get_volume_db(), -80.00, delta/2))
		Song3.set_volume_db(lerp(Song3.get_volume_db(), 0.00, delta))
		if is_equal_approx(0.00,Song3.get_volume_db()) and is_equal_approx(-80.00,Song2.get_volume_db()):
			cycleNumber = 3
			queueSong()
			print_debug("fade complete!")
			set_physics_process(false)
	elif cycleNumber == 3:
		Song3.set_volume_db(lerp(Song3.get_volume_db(), -80.00, delta/2))
		Song1.set_volume_db(lerp(Song1.get_volume_db(), 0.00, delta))
		if is_equal_approx(0.00,Song1.get_volume_db()) and is_equal_approx(-80.00,Song3.get_volume_db()):
			cycleNumber = 1
			queueSong()
			print_debug("fade complete!")
			set_physics_process(false)
