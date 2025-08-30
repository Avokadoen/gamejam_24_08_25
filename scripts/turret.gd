extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
@onready var projectile = load("res://scenes/projectile.tscn")

@export var timer: Timer
@export var count = 1
@export var rot_degrees_speed = 0
@export var max_angle_degrees = 360
@export var start_rot_offset_degrees = 0

func _ready() -> void:
	if timer != null:
		timer.timeout.connect(_on_timer_timeout)
		timer.start()

func _process(delta: float) -> void:
	rotation_degrees += delta * rot_degrees_speed
	
func _on_timer_timeout() -> void:
	for i in range(count):
		var angle_degrees = max_angle_degrees * i / count
		shoot(angle_degrees + global_rotation_degrees)
	timer.start()
		
func shoot(angle_degrees):
	var instance = projectile.instantiate()
	var dir = Vector2(1, 0).rotated(angle_degrees * PI / 180)
	instance.dir = dir
	instance.startPos = global_position
	instance.startRot = (angle_degrees + start_rot_offset_degrees) * PI / 180
	main.add_child.call_deferred(instance)
