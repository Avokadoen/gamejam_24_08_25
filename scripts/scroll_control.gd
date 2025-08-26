@tool
extends Node2D

@export var target_canvas: CanvasItem
@export_range(0, 1, 0.01, "How fast should background scroll")  var scroll_rate: float = 0.3

func _process(_delta) -> void:
	if Engine.is_editor_hint(): 
		target_canvas.material.set_shader_parameter("scroll_rate", 0)


func _ready() -> void:
	target_canvas.material.set_shader_parameter("scroll_rate", scroll_rate)
