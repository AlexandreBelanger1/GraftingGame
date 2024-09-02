class_name Seed extends CharacterBody2D

var targetPosition
var rootType = "mediumRoots"
var stemType = "pansyStem"
var flowerType = "pansyFlower"
var speed = 250
var direction = Vector2()

func _ready():
	set_physics_process(false)


func generateSeed(root:String,stem:String,flower:String):
	rootType = root
	stemType = stem
	flowerType = flower


func flyToPouch():
	set_physics_process(true)


func _physics_process(delta):
	targetPosition = Global.seedPouch.get_global_position()
	direction = targetPosition - global_position
	velocity = direction * speed
	var _collision_info = move_and_collide(velocity.normalized() * delta * speed)

func collectSeed():
	SignalBus.collectSeed.emit(rootType,stemType,flowerType)
	queue_free()

func _on_mouse_entered():
	flyToPouch()
