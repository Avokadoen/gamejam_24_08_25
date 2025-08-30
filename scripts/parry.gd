extends Area2D

@export var capacity: int = 3
@export var launch_speed: float = 500

@export var duration_sec: float
@export var cooldown_sec: float

@export_flags_2d_physics var projectile_collision_layer
@export_flags_2d_physics var projectile_collision_mask

enum State { Ready, Active, Cooldown }
var state: State = State.Ready

var ready_color: Color = Color.from_rgba8(255, 255, 255, 50)
var active_color: Color = Color.from_rgba8(0, 255, 0, 50)
var cooldown_color: Color = Color.from_rgba8(255, 0, 0, 50)

var projectiles = []
var collision_shape: CollisionShape2D
var timer: Timer

func _ready() -> void:
	collision_shape = $CollisionShape2D
	timer = $Timer

	monitoring = false
	collision_shape.debug_color = ready_color
	timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
	match state:
		State.Ready:
			if Input.is_action_just_pressed("parry"):
				release_projectiles()
				monitoring = true
				collision_shape.debug_color = active_color
				state = State.Active
				timer.start(duration_sec)

func _on_timer_timeout() -> void:
	match state:
		State.Active:
			monitoring = false
			collision_shape.debug_color = cooldown_color
			state = State.Cooldown
			timer.start(cooldown_sec)
		State.Cooldown:
			collision_shape.debug_color = ready_color
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
