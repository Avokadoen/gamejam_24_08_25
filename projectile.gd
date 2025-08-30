extends CharacterBody2D

@export var speed = 100
@export var lifetime = 5

var dir: Vector2
var startPos: Vector2
var startRot: float

var timer: Timer

func _ready() -> void:
	global_position = startPos
	global_rotation = startRot
	velocity = speed * dir
	timer = get_node("Timer")
	timer.start(lifetime)
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_timer_timeout() -> void:
	queue_free()
