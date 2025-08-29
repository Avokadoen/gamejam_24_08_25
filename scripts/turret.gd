extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
@onready var projectile = load("res://projectile.tscn")

@export var interval_msec = 1000
@export var count = 1
@export var rot_speed = 0
@export var max_angle = 360

var prev_fire_msec = 0

func _process(delta: float) -> void:
	var elapsed_msec = Time.get_ticks_msec()
	
	rotation_degrees += delta * rot_speed
	
	if elapsed_msec - prev_fire_msec >= interval_msec:
		prev_fire_msec = elapsed_msec
		for i in range(count):
			var angle = max_angle * i / count
			shoot(angle + global_rotation)
		
func shoot(angle):
	var instance = projectile.instantiate()
	var dir = Vector2(1, 0).rotated(angle)
	instance.dir = dir
	instance.startPos = global_position
	instance.startRot = angle
	main.add_child.call_deferred(instance)
