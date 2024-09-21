class_name Seed extends CharacterBody2D

var targetPosition
var plantSpecialType = "none"
var rootType = "mediumRoots"
var stemType = "pansyStem"
var flowerType = "pansyFlower"
var speed = 250
var direction = Vector2()
var fallPosition
var fallingFlag = false
var fallSpeed = 0.1
var flyingFlag = false
var RNG = RandomNumberGenerator.new()
func _ready():
	set_physics_process(false)


func generateSeed(root:String,stem:String,flower:String):
	rootType = root
	stemType = stem
	flowerType = flower
	randomizeSpecialTypes()

func randomizeSpecialTypes():
	var rand = randf_range(0,100)
	if rand > 50:
		plantSpecialType = Global.specialTypeDict.keys().pick_random()

func flyToPouch():
	flyingFlag = true
	set_physics_process(true)


func _physics_process(delta):
	if flyingFlag:
		targetPosition = Global.seedPouch.get_global_position()
		direction = targetPosition - global_position
		velocity = direction * speed
		var _collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if fallingFlag and !flyingFlag:
		global_position.y = lerp(global_position.y, fallPosition, delta * fallSpeed)
		fallSpeed += 0.5
		if is_equal_approx(global_position.y,fallPosition):
			fallingFlag = false
			set_physics_process(false)

func collectSeed():
	SignalBus.collectSeed.emit(rootType,stemType,flowerType, plantSpecialType)
	queue_free()

func _on_mouse_entered():
	flyToPouch()

func fall(target):
	fallPosition = target
	fallingFlag = true
	set_physics_process(true)
	
