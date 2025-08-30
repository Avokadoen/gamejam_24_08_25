extends Node

@export var spawn_delay: float
@export var loop_path: Path2D
@export var enemy: Resource

var enemy_instance: Node2D = null
var path_pos: float = 0

func _ready() -> void:
	var spawn_on: Timer = get_child(0)
	spawn_on.start(spawn_delay)
	
func _on_timer_timeout() -> void:
	enemy_instance = enemy.instantiate()

func _physics_process(delta: float) -> void:
	if enemy_instance:
		var curve = loop_path.get_curve()
		curve.sample_baked(path_pos)
		path_pos = (path_pos + delta) - floorf(path_pos)
