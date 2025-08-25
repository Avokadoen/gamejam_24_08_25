extends Node2D

@export_range(0, 100, 1, "How fast should background scroll")  var scroll_rate: float = 1

func _physics_process(delta: float) -> void:
	position.x -= scroll_rate * delta
