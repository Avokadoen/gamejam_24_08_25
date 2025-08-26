extends Node2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]  

@export_range(-5, 5, 0.01, "How slow or fast the background should move relative in x to the player")
var distance_x: float = 1

@export_range(-5, 5, 0.01, "How slow or fast the background should move relative in y to the player")
var distance_y: float = 1


func _physics_process(delta: float) -> void:
	position.x -= (player.velocity.x * distance_x) * delta
	position.y -= (player.velocity.y * distance_y) * delta
