extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
@onready var projectile = load("res://scenes/projectile.tscn")

@export var count: int = 1
@export var interval_sec: float = 1
@export var projectile_speed: float = 100
@export var rot_degrees_speed: float = 0
@export var max_angle_degrees: float = 360
@export var start_rot_offset_degrees: float = 0

var timer: Timer

func _ready() -> void:
	timer = $Timer
	
	if timer != null:
		timer.timeout.connect(_on_timer_timeout)
		timer.start()

func _process(delta: float) -> void:
	rotation_degrees += delta * rot_degrees_speed
	
func _on_timer_timeout() -> void:
	for i in range(count):
		var angle_degrees = max_angle_degrees * i / count
		shoot(angle_degrees + global_rotation_degrees)
	timer.start(interval_sec)
		
func shoot(angle_degrees):
	var instance = projectile.instantiate()
	var dir = Vector2(1, 0).rotated(angle_degrees * PI / 180)
	instance.SPEED = projectile_speed
	instance.dir = dir
	instance.startPos = global_position
	instance.startRot = (angle_degrees + start_rot_offset_degrees) * PI / 180
	main.add_child.call_deferred(instance)
