extends Node2D

const scroll_speed = 100;

func _physics_process(delta: float) -> void:
	position.x += scroll_speed * delta
