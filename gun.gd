extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
@onready var projectile = load("res://projectile.tscn")

@export var muzzle_dist = 10
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func shoot():
	var instance = projectile.instantiate()
	var dir = Vector2(1, 0).rotated(rotation)
	instance.dir = dir
	instance.startPos = global_position + dir * muzzle_dist
	instance.startRot = rotation
	main.add_child.call_deferred(instance)
