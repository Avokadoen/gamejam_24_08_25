extends Area2D

@export var duration_msec: int
@export var cooldown_msec: int
@export var capacity: int

var last_parry_msec = 0

var projectiles = []

func _ready() -> void:
	deactivate()
	pass

func _process(delta: float) -> void:
	var elapsed_msec = Time.get_ticks_msec()
	var since_last_msec = elapsed_msec - last_parry_msec
	
	if monitoring:
		if since_last_msec >= duration_msec:
			deactivate()
	elif Input.is_action_just_pressed("catch"):
		if since_last_msec >= cooldown_msec and len(projectiles) < capacity:
			last_parry_msec = elapsed_msec
			activate()
	elif Input.is_action_just_pressed("release"):
		for projectile in projectiles:
			release_projectile(projectile)
		projectiles.clear()

func activate() -> void:
	monitoring = true
	print("Parry on")
	
func deactivate() -> void:
	monitoring = false
	print("Parry off")

func catch_projectile(projectile: Projectile) -> void:
	if len(projectiles) >= capacity or projectiles.has(projectile):
		return
	
	projectile.SPEED = 0
	projectiles.append(projectile)
	projectile.reparent.call_deferred(self)
	projectile.collision_layer = 8
	projectile.dir = Vector2.RIGHT
	projectile.global_rotation_degrees = -90
	print("Catch projectile")

func release_projectile(projectile: Projectile) -> void:
	var parent = get_tree().get_root()
	projectile.reparent.call_deferred(parent)
	projectile.SPEED = 500
	print("Release projectile")

func _on_area_entered(area: Area2D) -> void:
	if area is Projectile:
		catch_projectile(area)

func _on_body_entered(body: Node2D) -> void:
	pass
