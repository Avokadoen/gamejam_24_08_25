extends CharacterBody2D

@export var SPEED = 100

var dir : float
var startPos : Vector2
var startRot : float

func _ready() -> void:
	global_position = startPos
	global_rotation = startRot
	
func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()
