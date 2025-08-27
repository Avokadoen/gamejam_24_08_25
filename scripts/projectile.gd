extends Area2D

@export var SPEED = 100

@export_flags_2d_physics var on_player_parry_layer
@export_flags_2d_physics var on_player_parry_mask

var dir : Vector2
var startPos : Vector2
var startRot : float

func _ready() -> void:
	global_position = startPos
	global_rotation = startRot

func _physics_process(delta: float) -> void:
	position += dir * SPEED * delta;

func _on_body_entered(body: Node2D) -> void:
	print("test!")
