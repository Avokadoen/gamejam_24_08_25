extends Area2D

@export var duration_msec: int = 300
@export var cooldown_msec: int = 600
@export var capacity: int = 3
@export var launch_speed: float = 500

@export_flags_2d_physics var projectile_collision_layer
@export_flags_2d_physics var projectile_collision_mask

enum State { Ready, Active, Cooldown }
var state: State = State.Ready

var ready_color: Color = Color.from_rgba8(255, 255, 255, 50)
var active_color: Color = Color.from_rgba8(0, 255, 0, 50)
var cooldown_color: Color = Color.from_rgba8(255, 0, 0, 50)

var last_parry_msec = 0
var projectiles = []

func _ready() -> void:
	monitoring = false
	get_child(0).debug_color = ready_color
	pass

func _process(delta: float) -> void:
	match state:
		State.Ready:
			if Input.is_action_just_pressed("catch"):
				last_parry_msec = Time.get_ticks_msec()
				release_projectiles()
				monitoring = true
				get_child(0).debug_color = active_color
				state = State.Active
		State.Active:
			if Time.get_ticks_msec() - last_parry_msec >= duration_msec:
				monitoring = false
				get_child(0).debug_color = cooldown_color
				state = State.Cooldown
		State.Cooldown:
			if Time.get_ticks_msec() - last_parry_msec >= cooldown_msec:
				get_child(0).debug_color = ready_color
				state = State.Ready

func catch_projectile(projectile: Projectile) -> void:
	if len(projectiles) >= capacity or projectiles.has(projectile):
		return
	
	# Set projectile to collide with enemies instead of player
	projectile.collision_layer = projectile_collision_layer
	projectile.collision_mask = projectile_collision_mask
	
	# Freeze projectile
	projectiles.append(projectile)
	projectile.reparent.call_deferred(self)
	projectile.SPEED = 0
	
	# Set launch direction
	projectile.dir = Vector2.RIGHT
	projectile.global_rotation_degrees = -90
	
	print("Catch projectile")

func release_projectile(projectile: Projectile) -> void:
	var parent = get_tree().get_root()
	projectile.reparent.call_deferred(parent)
	projectile.SPEED = launch_speed
	print("Release projectile")

func release_projectiles() -> void:
	for projectile in projectiles:
		release_projectile(projectile)
	projectiles.clear()

func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		catch_projectile(area)

func _on_body_entered(body: Node2D) -> void:
	pass
