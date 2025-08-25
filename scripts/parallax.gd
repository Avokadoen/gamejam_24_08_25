extends Node2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]  

@export_range(1, 10, 0.5, "How slow or fast the background should move relative to the player")
var distance: float = 1

func _physics_process(delta: float) -> void:
	position.x -= (player.velocity.x / distance) * delta
	position.y -= (player.velocity.y / distance) * delta
