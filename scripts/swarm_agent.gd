extends Node

@export var spawn_delay: float
@export var loop_path: Path2D
@export var enemy: Resource

@export var move_speed: float = 100
var path_pos: float = 0

@onready var main = get_tree().get_root().get_node("Node2D");

var enemy_instance: Node2D = null

func _ready() -> void:
	var spawn_on: Timer = get_child(0)
	spawn_on.start(spawn_delay)
	
	
func _on_timer_timeout() -> void:
	enemy_instance = enemy.instantiate()
	main.add_child.call_deferred(enemy_instance)
	update_enemy_instance(0)

func _physics_process(delta: float) -> void:
	update_enemy_instance(delta)
			
func update_enemy_instance(delta: float) -> void:
	if enemy_instance:
		var curve = loop_path.get_curve()
		enemy_instance.position = curve.sample_baked(path_pos, true) + loop_path.position
		path_pos += move_speed * delta;
		if (path_pos > curve.get_baked_length()):
			path_pos -= curve.get_baked_length()
