extends Node2D

@onready var main = get_tree().get_root().get_node("Node2D");
@onready var projectile = load("res://projectile.tscn")

func _ready() -> void:
	while 100 > 0:
		shoot()
		await get_tree().create_timer(1.0).timeout
	
func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.startPos = global_position
	instance.startRot = rotation
	main.add_child.call_deferred(instance)
