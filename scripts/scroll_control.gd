@tool
extends Node2D

@export var target_canvas: CanvasItem
@export_range(0, 1, 0.01, "How fast should background scroll")  var scroll_rate: float = 0.3

var time: float = 0
var player: Player 

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 
	target_canvas.material.set_shader_parameter("scroll_rate", scroll_rate)
	player = get_tree().get_nodes_in_group("Player")[0]
	

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		target_canvas.material.set_shader_parameter("scroll_rate", 0)
	else:
		var player_is_alive = player.health > 0
		if get_tree().paused == false && player_is_alive:
			time += delta

	target_canvas.material.set_shader_parameter("scroll_rate", scroll_rate)
	target_canvas.material.set_shader_parameter("time", time)
