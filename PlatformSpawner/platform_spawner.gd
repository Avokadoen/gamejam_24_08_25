@tool
extends Node2D

@export var platform_scene: PackedScene

# X spacing controls (Inspector sliders)
@export_range(16.0, 1024.0, 8.0, "or_greater") var spacing_px: float = 240.0
@export_range(0.0, 1024.0, 8.0, "or_greater") var first_offset_px: float = 240.0
@export_range(0.0, 1024.0, 1.0, "or_greater") var min_vertical_gap_px: float = 48.0
@export var tries_per_slot: int = 64
@export var start_from: NodePath

#Max number of platforms that can spawn per iteration
@export var max_num_plat: int = 3

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
		var num_platforms := rng.randi_range(1, max_num_plat)

		# get Y positions separated by at least min_vertical_gap_px
		var ys := _pick_separated_ys(rng, num_platforms, y_min, y_max, min_vertical_gap_px, tries_per_slot)
		for y in ys:
			out.append(area.to_global(Vector2(cur_x, y)))

		cur_x += spacing_px

	return out

func _pick_separated_ys(
	rng: RandomNumberGenerator,
	count: int,
	y_min: float,
	y_max: float,
	gap: float,
	tries_per_slot: int = 64
) -> Array[float]:
	var ys: Array[float] = []
	if count <= 0:
		return ys

	# No gap requested → just sample
	if gap <= 0.0:
		for i in range(count):
			ys.append(rng.randf_range(y_min, y_max))
		return ys

	# Cap by what can actually fit in the band with the requested gap
	var band_h := y_max - y_min
	var capacity := int(floor(band_h / gap)) + 1
	count = min(count, max(1, capacity))

	# Rejection sampling with a sensible try limit
	var tries := 0
	var limit : float = max(tries_per_slot * count, 1)
	while ys.size() < count and tries < limit:
		var c := rng.randf_range(y_min, y_max)
		var ok := true
		for yy in ys:
			if abs(c - yy) < gap:
				ok = false
				break
		if ok:
			ys.append(c)
		tries += 1

	# (optional) keep them sorted for a tidy look
	ys.sort()
	return ys


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return  # don't move in the editor
	_move_parent_left(delta)

func _move_parent_left(delta: float) -> void:
	var p: Node2D = get_parent() as Node2D
	if p != null:
		position.x -= scroll_speed_px_sec * delta
