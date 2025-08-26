@tool
extends Node2D

@export var target_canvas: CanvasItem
@export_range(0, 10, 0.01, "How transparent a given color intensity should be")  var whiteness_to_alpha_modifier: float = 0.3
@export_range(0, 1, 0.01, "How fast should background scroll")  var scroll_rate: float = 0.3

func _process(_delta) -> void:
	if Engine.is_editor_hint(): 
		target_canvas.material.set_shader_parameter("whiteness_to_alpha_modifier", whiteness_to_alpha_modifier)
		target_canvas.material.set_shader_parameter("scroll_rate", scroll_rate)

func _ready() -> void:
	target_canvas.material.set_shader_parameter("whiteness_to_alpha_modifier", whiteness_to_alpha_modifier)
	target_canvas.material.set_shader_parameter("scroll_rate", scroll_rate)
