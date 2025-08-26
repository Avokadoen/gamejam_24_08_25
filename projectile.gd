extends CharacterBody2D

@export var SPEED = 100

var dir : Vector2
var startPos : Vector2
var startRot : float

func _ready() -> void:
	global_position = startPos
	global_rotation = startRot
	velocity = SPEED * dir
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
