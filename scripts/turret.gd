extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
@onready var projectile = load("res://scenes/projectile.tscn")

@export var interval_msec = 1000
@export var count = 1
@export var rot_degrees_speed = 0
@export var max_angle_degrees = 360
@export var start_rot_offset_degrees = 0

var prev_fire_msec = 0

func _process(delta: float) -> void:
	var elapsed_msec = Time.get_ticks_msec()
	
	rotation_degrees += delta * rot_degrees_speed
	
	if elapsed_msec - prev_fire_msec >= interval_msec:
		prev_fire_msec = elapsed_msec
		for i in range(count):
			var angle_degrees = max_angle_degrees * i / count
			shoot(angle_degrees + global_rotation_degrees)
		
func shoot(angle_degrees):
	var instance = projectile.instantiate()
	var dir = Vector2(1, 0).rotated(angle_degrees * PI / 180)
	instance.dir = dir
	instance.startPos = global_position
	instance.startRot = (angle_degrees + start_rot_offset_degrees) * PI / 180
	main.add_child.call_deferred(instance)
