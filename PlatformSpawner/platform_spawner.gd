@tool
extends Node2D

@export var platform_scene: PackedScene

# X spacing controls (Inspector sliders)
@export_range(16.0, 1024.0, 8.0, "or_greater") var spacing_px: float = 240.0
@export_range(0.0, 1024.0, 8.0, "or_greater") var first_offset_px: float = 240.0
@export var start_from: NodePath

# --- NEW: random Y band (relative to SpawnArea's vertical center) ---
# Example: -150..+150 picks a 300px tall band centered in the area.
@export var y_min_offset_px: float = -150.0
@export var y_max_offset_px: float =  150.0

@export var random_seed: int = 12345  # deterministic layout (editor & runtime)

@export var scroll_speed_px_sec: float = 60.0  # how fast to drag left

@onready var area: Area2D = %SpawnArea
@onready var cshape: CollisionShape2D = %SpawnArea2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var pts := _compute_points()
	for p in pts:
		var inst := platform_scene.instantiate()
		add_child(inst)
		if inst is Node2D:
			(inst as Node2D).global_position = p

func _compute_points() -> Array[Vector2]:
	var out: Array[Vector2] = []
	if not platform_scene or not area or not cshape or not (cshape.shape is RectangleShape2D):
		return out

	var rect := cshape.shape as RectangleShape2D
	var half := rect.size * 0.5

	# Horizontal bounds (local to Area2D)
	var left_x  := cshape.position.x - half.x
	var right_x := cshape.position.x + half.x

	# Vertical band (local to Area2D)
	var top_y := cshape.position.y - half.y
	var bot_y := cshape.position.y + half.y
	var center_y := (top_y + bot_y) * 0.5

	var y_min: float = float(clamp(center_y + y_min_offset_px, top_y, bot_y))
	var y_max: float = float(clamp(center_y + y_max_offset_px, top_y, bot_y))
	
	if y_min > y_max:
		var t = y_min; y_min = y_max; y_max = t

	# Starting X
	var cur_x: float
	if start_from != NodePath(""):
		var sn := get_node_or_null(start_from) as Node2D
		if sn:
			var s_local := area.to_local(sn.global_position)
			cur_x = s_local.x + first_offset_px
		else:
			cur_x = left_x + spacing_px * 0.5
	else:
		cur_x = left_x + spacing_px * 0.5

	var rng := RandomNumberGenerator.new()
	rng.seed = random_seed

	while cur_x <= right_x + 0.001:
		var y := rng.randf_range(y_min, y_max)
		out.append(area.to_global(Vector2(cur_x, y)))
		cur_x += spacing_px

	return out

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return  # don't move in the editor
	_move_parent_left(delta)

func _move_parent_left(delta: float) -> void:
	var p: Node2D = get_parent() as Node2D
	if p != null:
		position.x -= scroll_speed_px_sec * delta
